
import Foundation
import simd

struct hit_record {
    var t: Float
    var p: float3
    var normal: float3
    init() {
        t = 0.0
        p = float3(x: 0.0, y: 0.0, z: 0.0)
        normal = float3(x: 0.0, y: 0.0, z: 0.0)
    }
}

protocol hitable {
    func hit(r: ray, _ tmin: Float, _ tmax: Float, inout _ rec: hit_record) -> Bool
}

class hitable_list: hitable  {
    var list = [hitable]()
    func add(h: hitable) {
        list.append(h)
    }
    func hit(r: ray, _ tmin: Float, _ tmax: Float, inout _ rec: hit_record) -> Bool {
        var hit_anything = false
        for item in list {
            if (item.hit(r, tmin, tmax, &rec)) {
                hit_anything = true
            }
        }
        return hit_anything
    }
}

class sphere: hitable  {
    var center = float3(x: 0.0, y: 0.0, z: 0.0)
    var radius = Float(0.0)
    init(c: float3, r: Float) {
        center = c
        radius = r
    }
    func hit(r: ray, _ tmin: Float, _ tmax: Float, inout _ rec: hit_record) -> Bool {
        let oc = r.origin - center
        let a = dot(r.direction, r.direction)
        let b = dot(oc, r.direction)
        let c = dot(oc, oc) - radius*radius
        let discriminant = b*b - a*c
        if discriminant > 0 {
            var t = (-b - sqrt(discriminant) ) / a
            if t < tmin {
                t = (-b + sqrt(discriminant) ) / a
            }
            if tmin < t && t < tmax {
                rec.t = t
                rec.p = r.point_at_parameter(rec.t)
                rec.normal = (rec.p - center) / float3(radius)
                return true
            }
        }
        return false
    }
}

func random_in_unit_sphere() -> float3 {
    var p = float3()
    repeat {
        p = 2.0 * float3(x: Float(drand48()), y: Float(drand48()), z: Float(drand48())) - float3(x: 1, y: 1, z: 1)
    } while dot(p, p) >= 1.0
    return p
}
