//
//  Scene.swift
//  ray
//
//  Created by Jay Lindelycke on 01/09/16.
//  Copyright © 2016 Jay Lindelycke. All rights reserved.
//

import Foundation
import UIKit

class Scene: UIView {
    var camera: Camera!
    var light: Point!
    var shapes: [Shape]!
    var background: Color!

    init(frame: CGRect, camera: Camera, light: Point, shapes: [Shape], background: Color) {
        self.camera = camera
        self.light = light
        self.shapes = shapes
        self.background = background
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        for pixel in camera.pixels {
            
            print("")
            print("---Pixel \(pixel.x):\(pixel.y)")
            let color: Color = RayController.getColor(ray: pixel.ray, light: light, shapes: shapes, camera: camera, background: background)
            
            context?.setFillColor(CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: color.components())!)
            context?.addRect(CGRect(x: CGFloat(pixel.x), y: CGFloat(pixel.y), width: 1, height: 1))
            context?.fillPath()
        }
    }
}
