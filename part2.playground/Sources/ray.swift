
import Foundation
import simd

struct ray {
    var origin: float3
    var direction: float3
    func point_at_parameter(t: Float) -> float3 {
        return origin + t * direction
    }
}

struct camera {
    let lower_left_corner: float3
    let horizontal: float3
    let vertical: float3
    let origin: float3
    init() {
        lower_left_corner = float3(x: -2.0, y: 1.0, z: -1.0)
        horizontal = float3(x: 4.0, y: 0, z: 0)
        vertical = float3(x: 0, y: -2.0, z: 0)
        origin = float3()
    }
    func get_ray(u: Float, _ v: Float) -> ray {
        return ray(origin: origin, direction: lower_left_corner + u * horizontal + v * vertical - origin);
    }
}

func color(r: ray, _ world: hitable) -> float3 {
    var rec = hit_record()
    if world.hit(r, 0.01, Float.infinity, &rec) {
        let target = rec.p + rec.normal + random_in_unit_sphere()
        return 0.5 * color(ray(origin: rec.p, direction: target - rec.p), world)
    } else {
        let unit_direction = normalize(r.direction)
        let t = 0.5 * (unit_direction.y + 1)
        return (1.0 - t) * float3(x: 1, y: 1, z: 1) + t * float3(x: 0.5, y: 0.7, z: 1.0)
    }
}
