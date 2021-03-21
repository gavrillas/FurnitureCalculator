//
//  UIColor+Extensions.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 15..
//  Copyright © 2021. kristof. All rights reserved.
//

import UIKit

public extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((hex >> 16) & 0xff) / CGFloat(255.0),
                  green: CGFloat((hex >> 8) & 0xff) / CGFloat(255.0),
                  blue: CGFloat(hex & 0xff) / CGFloat(255.0),
                  alpha: alpha)
    }
}

public extension UIColor {
    static let lightBrown = UIColor(hex: 0xA78156)
}
