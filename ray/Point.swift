//
//  Point.swift
//  ray
//
//  Created by Jay Lindelycke on 01/09/16.
//  Copyright © 2016 Jay Lindelycke. All rights reserved.
//

import Foundation

class Point {
    var x: Double = 0.0
    var y: Double = 0.0
    var z: Double = 0.0
    
    init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    func vector(to: Point) -> Point {
        return Point(x: to.x - self.x, y: to.y - self.y, z: to.z - self.z)
    }
    
    func normalized() -> Point {
        let hyp = sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
        return Point(x: self.x / hyp, y: self.y / hyp, z: self.z / hyp)
    }

    func dotProduct(with: Point) -> Double {
        return self.x * with.x + self.y * with.y + self.z * with.z
    }

    func reflected(across normal: Point) -> Point {
        let projection = 2 * self.dotProduct(with: normal)
        let projectionNormal = normal * projection
        return self - projectionNormal
    }
    
    static func - (first: Point, second: Point) -> Point {
        let x = first.x - second.x
        let y = first.y - second.y
        let z = first.z - second.z
        return Point(x: x, y: y, z: z)
    }

    static func * (first: Point, second: Double) -> Point {
        let x = first.x * second
        let y = first.y * second
        let z = first.z * second
        return Point(x: x, y: y, z: z)
    }

    static func + (first: Point, second: Point) -> Point {
        let x = first.x + second.x
        let y = first.y + second.y
        let z = first.z + second.z
        return Point(x: x, y: y, z: z)
    }
    
    static prefix func - (first: Point) -> Point {
        return Point(x: -first.x, y: -first.y, z: -first.z)
    }
}
