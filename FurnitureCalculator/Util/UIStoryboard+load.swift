//
//  UIStoryboard+load.swift
//  FurnitureCalculator
//
//  Created by kristof on 2020. 01. 29..
//  Copyright © 2020. kristof. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class func load<Controller: UIViewController>(from storyboard: String, type: Controller.Type, identifier: String? = nil, isInit: Bool = false) -> Controller {
        let sboard = UIStoryboard(name: storyboard, bundle: nil)
        return sboard.load(type: type, identifier: identifier, isInit: isInit)
    }

    func load<Controller: UIViewController>(type: Controller.Type, identifier: String? = nil, isInit: Bool = false) -> Controller {
        if isInit {
            guard let vc = instantiateInitialViewController() as? Controller else { fatalError() }
            return vc
        }
        let identifier = identifier ?? NSStringFromClass(Controller.self).components(separatedBy: ".").last ?? ""
        guard let vc = instantiateViewController(withIdentifier: identifier) as? Controller else { fatalError() }
        return vc
    }
}
