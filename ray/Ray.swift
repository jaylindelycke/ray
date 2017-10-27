//
//  Ray.swift
//  ray
//
//  Created by Jay Lindelycke on 22/09/16.
//  Copyright © 2016 Jay Lindelycke. All rights reserved.
//

import Foundation

class Ray {
    var origin: Point
    var direction: Point
	var inside: Bool
	var originRefractionIndex: Double?

	init(origin: Point, direction: Point, inside: Bool = false, originRefractionIndex: Double? = nil) {
        self.origin = origin
        self.direction = direction
		self.inside = inside
		self.originRefractionIndex = originRefractionIndex
    }
    
	func refract(at intersection: Intersection, sceneRefractionIndex: Double) -> Ray? {
		var indexFrom = sceneRefractionIndex
		var indexInto = intersection.shape.material.refractionIndex
		var intersectionNormal = intersection.normal

		if self.inside {
			 swap(&indexFrom, &indexInto)
			 intersectionNormal = -intersection.normal
		}

		let indexRatio = indexFrom / indexInto
		let cosI = intersectionNormal.dotProduct(with: self.direction)
		let c2 = 1.0 - indexRatio * indexRatio * (1.0 - cosI * cosI)
		if c2 > 0.0 {
			let T = (self.direction * indexRatio + intersectionNormal * (indexRatio * cosI - sqrt(c2))).normalized()
			let refractedRay = Ray(origin: intersection.point + T * 0.001, direction: T, inside: !self.inside)

			return refractedRay
		}

		return nil

		//TODO
		//Calculate .inside instead of setting it hardcoded (so it works with intersecting glass shapes)
	}

}
