//
//  ViewModelType.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 27..
//  Copyright © 2021. kristof. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
