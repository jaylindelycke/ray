//
//  Plane.swift
//  ray
//
//  Created by Jay Lindelycke on 2017-07-01.
//  Copyright © 2017 Jay Lindelycke. All rights reserved.
//

import Foundation

class Plane: Shape {
    var material: Material
    var center: Point
    var normal: Point
    var id: String
    
    init(center: Point, normal: Point, material: Material, id: String) {
        self.center = center
        self.material = material
        self.normal = normal
        self.id = id
    }

    internal func normal(intersection: Point) -> Point? {
        return self.normal
    }
    
    internal func intersection(ray: Ray) -> Double? {
        let denom = self.normal.dotProduct(with: ray.direction)
        if abs(denom) > 0.0001 { //if not bigger than nearly zero, the ray goes parallell to plane and never intersects, so return nil
            let centerToRay = self.center - ray.origin
            let distance = centerToRay.dotProduct(with: self.normal) / denom
            // distance along ray until intersection
            if distance >= 0 { //if less than zero intersecion is behind camera, return nil
                return distance - 0.0001
            }
        }
        return nil
    }
}
