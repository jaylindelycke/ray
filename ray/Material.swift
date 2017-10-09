//
//  Material.swift
//  ray
//
//  Created by Jay Lindelycke on 2017-07-02.
//  Copyright © 2017 Jay Lindelycke. All rights reserved.
//

import Foundation

class Material {
    var color: Color
    var shininess: Double
    var reflectivity: Double
    var opacity: Double
    var refractionIndex: Double

	// swiftlint:disable line_length
    init(color: Color, shininess: Double = 0, reflectivity: Double = 0, opacity: Double = 1, refractionIndex: Double = 1) {
        self.color = color
        self.shininess = shininess
        self.reflectivity = reflectivity
        self.opacity = opacity
        self.refractionIndex = refractionIndex
    }
}
