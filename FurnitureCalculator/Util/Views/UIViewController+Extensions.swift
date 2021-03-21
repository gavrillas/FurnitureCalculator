//
//  UIViewController+Extensions.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 15..
//  Copyright © 2021. kristof. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIViewController {
    func setUpDismissKeyboard() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
