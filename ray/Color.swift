//
//  Color.swift
//  ray
//
//  Created by Jay Lindelycke on 18/09/16.
//  Copyright © 2016 Jay Lindelycke. All rights reserved.
//

import Foundation
import UIKit

class Color {
    var red: Double
    var green: Double
    var blue: Double
    
    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    func components() -> [CGFloat] {
        return [CGFloat(self.red), CGFloat(self.green), CGFloat(self.blue), 1.0]
    }

    static func * (first: Color, second: Double) -> Color {
        let red = first.red * second
        let green = first.green * second
        let blue = first.blue * second
        return Color(red: red, green: green, blue: blue)
    }

    static func + (first: Color, second: Color) -> Color {
        let red = Swift.min(first.red + second.red, 1)
        let green = Swift.min(first.green + second.green, 1)
        let blue = Swift.min(first.blue + second.blue, 1)
        return Color(red: red, green: green, blue: blue)
    }
}

extension Array where Element:Color {
    func blended() -> Color {
        var red: Double = 0
        var green: Double = 0
        var blue: Double = 0
        
        for color in self {
            red += color.red
            green += color.green
            blue += color.blue
        }
        red /= Double(self.count)
        green /= Double(self.count)
        blue /= Double(self.count)
        
        return Color(red: red, green: green, blue: blue)
    }
    
    func added() -> Color {
        var red: Double = 0
        var green: Double = 0
        var blue: Double = 0
        
        for color in self {
            red = Swift.max(red, color.red)
            green = Swift.max(green, color.green)
            blue = Swift.max(blue, color.blue)
        }
        
        return Color(red: red, green: green, blue: blue)
    }
}
