//
//  Storyboards.swift
//  FurnitureCalculator
//
//  Created by kristof on 2020. 12. 19..
//  Copyright © 2020. kristof. All rights reserved.
//

import UIKit

enum Storyboards: String {
    case main
    case calculator
}

extension Storyboards {
    static func get(storyboard: Storyboards) -> UIStoryboard {
        let raw = storyboard.rawValue
        let name = raw.prefix(1).uppercased() + raw.dropFirst()
        return UIStoryboard(name: name, bundle: Bundle.main)
    }
    
    static func load<Controller: UIViewController>(storyboard: Storyboards, type: Controller.Type) -> Controller{
        let sboard = Storyboards.get(storyboard: storyboard)
        return sboard.load(type: type)
    }
}
