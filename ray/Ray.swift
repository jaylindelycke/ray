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

	init(origin: Point, direction: Point, inside: Bool = false) {
        self.origin = origin
        self.direction = direction
		self.inside = inside
    }
    
    func refract(at intersection: Intersection) -> Ray? {
		let originalRay = self
		let refractionCoefficient = intersection.shape.material.refractionIndex
		var rCoeff = refractionCoefficient
		if originalRay.inside { // Leaving refractive material
			rCoeff = 1.0
		}
		let originalRayMediumRefractionIndex = !originalRay.inside ? 1.0 : refractionCoefficient
		let n = originalRayMediumRefractionIndex / rCoeff
		var N = intersection.normal
		if originalRay.inside {
			N = -N
		}
		let cosI = (N.dotProduct(with: originalRay.direction))
		let c2 = 1.0 - n * n * (1.0 - cosI * cosI)
		if c2 > 0.0 {
			let T = (originalRay.direction * n + N * (n * cosI - sqrt(c2))).normalized()
			let newRay = Ray(origin: intersection.point + T * 0.001, direction: T, inside: !originalRay.inside)

			return newRay
		}

		return nil
	}

}
