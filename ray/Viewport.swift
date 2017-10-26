//
//  Viewport.swift
//  ray
//
//  Created by Jay Lindelycke on 01/09/16.
//  Copyright © 2016 Jay Lindelycke. All rights reserved. //

import Foundation
import UIKit

class Viewport: UIView {
	var pixels: [Pixel]
	weak var cameraDelegate: Camera?
	var raytraceController: RayTraceController
	var screenScale: CGFloat
	let pixelSize = 1 //Raise this to 3 or more to render a quicker draft

	init(cameraDelegate: Camera) {
		self.pixels = []
		self.cameraDelegate = cameraDelegate
		self.raytraceController = RayTraceController(sceneDelegate: cameraDelegate.sceneDelegate)
		self.screenScale = UIScreen.main.scale
		let pixelWidth = UIScreen.main.bounds.size.width * screenScale
		let pixelHeight = pixelWidth * 0.56
		let imageAspectRatio = Double(pixelWidth) / Double(pixelHeight)
		let scale = tan(cameraDelegate.fieldOfView / 2 * .pi / 180)

		for pixelY in stride(from: 1, to: Int(pixelHeight), by: pixelSize) {
			for pixelX in stride(from: 1, to: Int(pixelWidth), by: pixelSize) {
				let sceneX = (2 * ((Double(pixelX) + 0.5) / Double(pixelWidth)) - 1) * scale * imageAspectRatio
				let sceneY = (1 - 2 * ((Double(pixelY) + 0.5) / Double(pixelHeight))) * scale
				let scenePoint = Point(x: Double(sceneX), y: Double(sceneY), z: -1.0)
				let rayDirection = cameraDelegate.origin.vector(to: scenePoint).normalized()
				self.pixels.append(Pixel(x: pixelX, y: pixelY, ray: Ray(origin: cameraDelegate.origin, direction: rayDirection)))
			}
		}
		print("pixelWidth: \(pixelWidth)")
		print("pixels.count: \(pixels.count)")

		let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: pixelWidth, height: pixelHeight))
		super.init(frame: frame)
	}

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
		context?.scaleBy(x: 1 / screenScale, y: 1 / screenScale)
		for pixel in pixels {
			let color = raytraceController.getColor(ray: pixel.ray)
			context?.setFillColor(CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: color.components())!)
			context?.addRect(CGRect(x: pixel.x, y: pixel.y, width: pixelSize, height: pixelSize))
			context?.fillPath()
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
