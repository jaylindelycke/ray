//
//  Shape
//  ray
//
//  Created by Jay Lindelycke on 2017-07-01.
//  Copyright © 2017 Jay Lindelycke. All rights reserved.
//

import Foundation

protocol Shape {
    var center: Point { get set }
    var material: Material { get set }
    func intersection(ray: Ray) -> Double?
    func normal(intersection: Point) -> Point?
    var id: String { get set }
}
