//
//  Camera.swift
//  ray
//
//  Created by Jay Lindelycke on 05/09/16.
//  Copyright © 2016 Jay Lindelycke. All rights reserved.
//

import Foundation

class Camera {
    var origin: Point
    var pixels: [Pixel] = []

    init(fieldOfView: Double, imageWidth: Int, imageHeight: Int) {
        self.origin = Point(x: 0, y: 0, z: 0)
        let imageAspectRatio = Double(imageWidth) / Double(imageHeight)
        let scale = tan(fieldOfView / 2 * .pi / 180)

        for pixelY in 1 ... imageHeight {
            for pixelX in 1 ... imageWidth {
                let sceneX = (2 * ((Double(pixelX) + 0.5) / Double(imageWidth)) - 1) * scale * imageAspectRatio
                let sceneY = (1 - 2 * ((Double(pixelY) + 0.5) / Double(imageHeight))) * scale
                let scenePoint = Point(x: Double(sceneX), y: Double(sceneY), z: -1.0)
                let rayDirection = origin.vector(to: scenePoint).normalized()
                self.pixels.append(Pixel(x: pixelX, y: pixelY, ray: Ray(origin: origin, direction: rayDirection)))
            }
        }
    }

	class Pixel {
        var x: Int
        var y: Int
        var ray: Ray

        init(x: Int, y: Int, ray: Ray) {
            self.x = x
            self.y = y
            self.ray = ray
        }
    }

}
