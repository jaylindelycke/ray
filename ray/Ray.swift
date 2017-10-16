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
        let incident = self.direction
        var normal = intersection.normal
        let fromRefractionIndex = 1.0
        let intoRefractionIndex = intersection.shape.material.refractionIndex
        var indexScale = intoRefractionIndex / fromRefractionIndex
        var cosIncident = -incident.dotProduct(with: normal)
        
        if cosIncident < 0 {
            cosIncident = -cosIncident
        } else {
			print("turn normal and index")
            normal = -normal
            indexScale = fromRefractionIndex / intoRefractionIndex
        }
	
        let sinTransmissionSquared = indexScale * indexScale * (1 - cosIncident * cosIncident)
        if sinTransmissionSquared > 1 {
            return nil
        }
        let cosTransmission = sqrt(1 - sinTransmissionSquared)
        let refraction = (incident * indexScale + (normal * (indexScale * cosIncident - cosTransmission))).normalized()
        
        print("-construct refraction ray, direction z: \(refraction.z)")
        
        print("cosIncident: \(cosIncident)")
        print("sinTransmissionSquared: \(sinTransmissionSquared))")
        print("cosTransmission: \(cosTransmission))")
        print("-")

        return Ray(origin: intersection.point + ((refraction * 0.001)), direction: refraction)
    }

	func refract2(at intersection: Intersection) -> Ray? {
		print("func refract()")
		var cosIncident = -self.direction.dotProduct(with: intersection.normal)
		print("cosInsident (start): \(cosIncident)")
		let inside = cosIncident > 0 ? false : true
		print("inside: \(inside)")

		var n = 1 / 1.0
		var N = intersection.normal
		if inside {
			N = -N
			n = 1.0 / 1
			print("turn normal, turn refractionDiff, cosIncident): \(cosIncident)")
		} else {
			cosIncident = -cosIncident
			print("turn cosIncident, cosIncident: \(cosIncident)")
		}

		let c2 = 1.0 - n * n * (1.0 - cosIncident * cosIncident)
		if c2 > 0.0 {
			let T = (self.direction * n + N * (n * cosIncident - sqrt(c2))).normalized()
			let newRay = Ray(origin: intersection.point + ((T * 0.001)), direction: T)
			return newRay
		}

		return nil
	}

	func refract3(at hit: Intersection) -> Ray? {
		let originalRay = self
		let refractionCoefficient = hit.shape.material.refractionIndex
		var rCoeff = refractionCoefficient
		if originalRay.inside { // Leaving refractive material
			rCoeff = 1.0
		}
		let originalRayMediumRefractionIndex = !originalRay.inside ? 1.0 : refractionCoefficient
		let n = originalRayMediumRefractionIndex / rCoeff
		var N = hit.normal
		if originalRay.inside {
			N = -N
		}
		let cosI = (N.dotProduct(with: originalRay.direction))
		let c2 = 1.0 - n * n * (1.0 - cosI * cosI)
		if c2 > 0.0 {
			let T = (originalRay.direction * n + N * (n * cosI - sqrt(c2))).normalized()
			let newRay = Ray(origin: hit.point + T * 0.001, direction: T, inside: !originalRay.inside)

			return newRay
		}

		return nil
	}

}
