//
//  Viewport.swift
//  ray
//
//  Created by Jay Lindelycke on 01/09/16.
//  Copyright © 2016 Jay Lindelycke. All rights reserved.
//

import Foundation
import UIKit

class Viewport: UIView {
	var pixels: [[Pixel]]! = []
	weak var cameraDelegate: Camera!
	var raytraceController: RayTraceController!

	init(cameraDelegate: Camera) {
		self.cameraDelegate = cameraDelegate
		self.raytraceController = RayTraceController(sceneDelegate: cameraDelegate.sceneDelegate)
		let imageWidth = UIScreen.main.bounds.size.width
		let imageHeight = imageWidth * 0.56
		let imageAspectRatio = Double(imageWidth) / Double(imageHeight)
		let scale = tan(cameraDelegate.fieldOfView / 2 * .pi / 180)

		for pixelY in 1 ... Int(imageHeight) {
			var pixelRow: [Pixel] = []
			for pixelX in 1 ... Int(imageWidth) {
				let sceneX = (2 * ((Double(pixelX) + 0.5) / Double(imageWidth)) - 1) * scale * imageAspectRatio
				let sceneY = (1 - 2 * ((Double(pixelY) + 0.5) / Double(imageHeight))) * scale
				let scenePoint = Point(x: Double(sceneX), y: Double(sceneY), z: -1.0)
				let rayDirection = cameraDelegate.origin.vector(to: scenePoint).normalized()
				pixelRow.append(Pixel(x: pixelX, y: pixelY, ray: Ray(origin: cameraDelegate.origin, direction: rayDirection)))
			}
			pixels.append(pixelRow)
		}

		let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: imageWidth, height: imageHeight))

		super.init(frame: frame)
	}

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

		for (index, bit) in stride(from: 6, through: 6, by: -1).enumerated() {
			let size = Int(truncating: NSDecimalNumber(decimal: pow(2, bit)))
			let start = index == 0 ? 0 : size

			let offsetY = start //make y run twice on first row
			for pixelY in stride(from: offsetY, to: pixels.count, by: size + start) {
				let offsetX = pixelY % (size + start) == 0 ? start : 0
				for pixelX in stride(from: offsetX, to: pixels[pixelY].count, by: size + offsetX) {

					let pixel = pixels[pixelY][pixelX]
					let color = raytraceController.getColor(ray: pixel.ray)

					context?.setFillColor(CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: color.components())!)
					context?.addRect(CGRect(x: pixel.x, y: pixel.y, width: size, height: size))
					context?.fillPath()
				}
			}

			self.setNeedsDisplay()
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
