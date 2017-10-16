//
//  Intersection.swift
//  ray
//
//  Created by Jay Lindelycke on 2017-10-16.
//  Copyright © 2017 Jay Lindelycke. All rights reserved.
//

import Foundation

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
