//
//  RayController.swift
//  ray
//
//  Created by Jay Lindelycke on 2017-07-01.
//  Copyright © 2017 Jay Lindelycke. All rights reserved.
//

import Foundation

private func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

class RayController {
	static var index = 0
	
    static func getColor(ray: Ray, light: Point, shapes: [Shape], camera: Camera, background: Color, retraceDepth: Int = 0) -> Color {
        // Check for ray impacting a shape
        print("check ray for intersection")
        guard let intersection = getNearestIntersectionFor(ray: ray, shapes: shapes) else {
            print("no intersection, return background")
            return background
        }
        print("intersection point z: \(intersection.point.z)")

        // Shading
        let shapeColor = intersection.shape.material.color
        let ambientShade = 1.0
        let intersectionToCameraDirection = intersection.point.vector(to: camera.origin).normalized()
	
        // Ambient shading
        var shadingColor = shapeColor * ambientShade //TODO respect opacity?
        print("set shading ambient color from shape id: \(intersection.shape.id)")
        
        // Not obscured by shadow
        let intersectionToLightDirection = intersection.point.vector(to: light).normalized()
        let shadowRay = Ray(origin: intersection.point, direction: intersectionToLightDirection)
        if getNearestIntersectionFor(ray: shadowRay, shapes: shapes) == nil {
            
            // Diffuse shading
            let intersectionPointToLightDirection = intersection.point.vector(to: light).normalized()
            let diffuseShade = intersectionPointToLightDirection.dotProduct( with: intersection.normal )
            //shadingColor = shapeColor * diffuseShade + shadingColor
            
            // Specular
            if intersection.normal.dotProduct(with: intersectionPointToLightDirection) >= 0.0 {
                let reflectedLight = -intersectionPointToLightDirection.reflected(across: intersection.normal)
                let projection = reflectedLight.dotProduct(with: intersectionToCameraDirection)
                let specularColor = shapeColor * pow(max(0.0, projection), 30)
                let shininess = intersection.shape.material.shininess
                //shadingColor = specularColor * shininess + shadingColor
            }
        }

        // Retracing
        if retraceDepth < 2 {
            
            // Reflection
            let reflectivity = intersection.shape.material.reflectivity
            if reflectivity > 0 {
                let reflectionRay = Ray(origin: intersection.point, direction: -intersectionToCameraDirection.reflected(across: intersection.normal))
                //let reflectionColor = getColor(ray: reflectionRay, light: light, shapes: shapes, camera: camera, background: background, retraceDepth: retraceDepth + 1)
                //shadingColor = reflectionColor * reflectivity + shadingColor * (1 - reflectivity)
            }
            
            // Refraction
            let opacity = intersection.shape.material.opacity
            if opacity < 1 {
                print("shape is transparent, get refraction")
                
                //let incidence = Ray(origin: intersection.point - ray.direction, direction: ray.direction)
                if let refractionRay = ray.refract(at: intersection) {
                    print("incoming ray x: \(ray.direction.x) | refracted ray x: \(refractionRay.direction.x)")
                    print("incoming ray y: \(ray.direction.y) | refracted ray y: \(refractionRay.direction.y)")
                    print("incoming ray z: \(ray.direction.z) | refracted ray z: \(refractionRay.direction.z)")
                    print("the point z to refract at: \(intersection.point.z) ")

                    //return Color(red: 1, green: 0, blue: 0)
                    let refractionColor = getColor(ray: refractionRay, light: light, shapes: shapes, camera: camera, background: background, retraceDepth: retraceDepth + 1)
                    shadingColor = refractionColor
                }
            }
        } else {
            print("retrace depth reached, no more retracing")
        }
        
        return shadingColor
        
        //TODO
        //Add lightsource visibility (reflected). the light must have a physical form, like a plane
        //Add blur
        //Add antialias
        //shadow thru transparent object shouldnt be completely black
        //make refraction ray refract and on oposite side too
    }
    
    static func getNearestIntersectionFor(ray: Ray, shapes: [Shape]) -> Intersection? {
        var nearestDistance: Double? = nil
        var nearestPrimitive: Shape? = nil
        
        for shape in shapes {
            let distance = shape.intersection(ray: ray)
            if distance == nil {
                continue
            }
            if distance < nearestDistance || nearestDistance == nil {
                nearestDistance = distance
                nearestPrimitive = shape
            }
        }

        if let distance = nearestDistance, let primitive = nearestPrimitive {
            let intersectionPoint = ray.origin + ray.direction * distance
            let intersectionNormal = primitive.normal(intersection: intersectionPoint)
        
            return Intersection(point: intersectionPoint, normal: intersectionNormal!, shape: primitive)
        }
        
        return nil
    }

}

class Intersection {
    var point: Point
    var normal: Point
    var shape: Shape
    
    init(point: Point, normal: Point, shape: Shape) {
        self.point = point
        self.normal = normal
        self.shape = shape
    }
}