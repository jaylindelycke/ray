//
//  Camera.swift
//  ray
//
//  Created by Jay Lindelycke on 05/09/16.
//  Copyright © 2016 Jay Lindelycke. All rights reserved.
//

import Foundation

class Camera {
    var origin: Point!
	var fieldOfView: Double!
	var viewport: Viewport!
	weak var sceneDelegate: SceneViewController!

	init(origin: Point = Point(x: 0, y: 0, z: 0), fieldOfView: Double = 30, sceneDelegate: SceneViewController) {
		self.origin = origin
		self.fieldOfView = fieldOfView
		self.sceneDelegate = sceneDelegate
		self.viewport = Viewport(cameraDelegate: self)
	}
}
