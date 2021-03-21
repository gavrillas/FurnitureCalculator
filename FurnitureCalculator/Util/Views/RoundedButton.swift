//
//  RoundedButton.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 15..
//  Copyright © 2021. kristof. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

    @IBInspectable
    public var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue}
    }

}
