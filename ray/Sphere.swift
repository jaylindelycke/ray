//
//  Sphere.swift
//  ray
//
//  Created by Jay Lindelycke on 01/09/16.
//  Copyright © 2016 Jay Lindelycke. All rights reserved.
//

import Foundation

class Sphere: Shape {
    var center: Point
    var radius: Double
    var material: Material
    var vectorFromCamera: Point
    var dotProductFromCamera: Double
    var id: String

    init(center: Point, radius: Double, material: Material, cameraOrigin: Point, id: String = "") {
        self.center = center
        self.radius = radius
        self.material = material
        self.vectorFromCamera = cameraOrigin.vector(to: center)
        self.dotProductFromCamera = self.vectorFromCamera.dotProduct(with: self.vectorFromCamera)
        self.id = id
    }
    
    internal func normal(intersection: Point) -> Point? {
        let intersectionNormal = self.center.vector(to: intersection).normalized()
        return intersectionNormal
    }

    internal func intersection(ray: Ray) -> Double? {
        let rayToPoint = ray.origin.vector(to: self.center)
        let rayToAbovePoint = rayToPoint.dotProduct(with: ray.direction)
        
        if rayToAbovePoint < 0 {
            return nil
        }
        
        let pointToAboveSquared = rayToPoint.dotProduct(with: rayToPoint) - rayToAbovePoint * rayToAbovePoint
        
        if pointToAboveSquared > self.radius * self.radius {
            return nil
        }
        
        let intersectToAbovePoint = sqrt(self.radius * self.radius - pointToAboveSquared)
        
        var intersect1 = rayToAbovePoint - intersectToAbovePoint
        var intersect2 = rayToAbovePoint + intersectToAbovePoint
        
        if intersect1 > intersect2 {
            swap(&intersect1, &intersect2)
        }
        
        if intersect1 < 0 {
            intersect1 = intersect2
            if intersect1 < 0 {
                return nil
            }
        }
        
        return intersect1
    }
}
