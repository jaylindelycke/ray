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

    init(origin: Point, direction: Point) {
        self.origin = origin
        self.direction = direction
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

        return Ray(origin: intersection.point + (refraction * 0.001), direction: refraction)
    }

}
