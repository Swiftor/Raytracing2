
import CoreImage
import simd

public struct Pixel {
    var r: UInt8
    var g: UInt8
    var b: UInt8
    var a: UInt8
    public init(red: UInt8, green: UInt8, blue: UInt8) {
        r = red
        g = green
        b = blue
        a = 255
    }
}

public func imageFromPixels(width: Int, _ height: Int) -> CIImage {
    var pixel = Pixel(red: 0, green: 0, blue: 0)
    var pixels = [Pixel](count: width * height, repeatedValue: pixel)
    let world = hitable_list()
    var object = sphere(c: float3(x: 0, y: -100.5, z: -1), r: 100)
    world.add(object)
    object = sphere(c: float3(x: 0, y: 0, z: -1), r: 0.5)
    world.add(object)
    let cam = camera()
    for i in 0..<width {
        for j in 0..<height {
            var col = float3()
            let ns = 10
            for _ in 0..<ns {
                let u = (Float(i) + Float(drand48())) / Float(width)
                let v = (Float(j) + Float(drand48())) / Float(height)
                let r = cam.get_ray(u, v)
                col += color(r, world)
            }
            col /= float3(Float(ns))
            col = float3(sqrt(col.x), sqrt(col.y), sqrt(col.z))
            pixel = Pixel(red: UInt8(col.x * 255), green: UInt8(col.y * 255), blue: UInt8(col.z * 255))
            pixels[i + j * width] = pixel
        }
    }
    let bitsPerComponent = 8
    let bitsPerPixel = 32
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue) // alpha is last
    let providerRef = CGDataProviderCreateWithCFData(NSData(bytes: pixels, length: pixels.count * sizeof(Pixel)))
    let image = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, width * sizeof(Pixel), rgbColorSpace, bitmapInfo, providerRef, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
    return CIImage(CGImage: image!)
}