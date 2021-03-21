//
//  HomeNavigator.swift
//  FurnitureCalculator
//
//  Created by kristof on 2020. 01. 29..
//  Copyright © 2020. kristof. All rights reserved.
//

import UIKit

protocol HomeNavigator {
    func showFurnitures(measurement: Measurement)
    func showNewFurniture(measurement: Measurement)
    func showSummary(furniture: Furniture)
}

final class DefaultHomeNavigator: HomeNavigator {
    private weak var _navigationController: UINavigationController!
    
    private let _measurementUseCase = MeasurementRepository.make()
    private let _furnitureUseCase = FurnitureRepository.make()
    private let _componentUseCase = ComponentRepository.make()

    init(navigationController: UINavigationController) {
        _navigationController = navigationController
    }
    
    func showFurnitures(measurement: Measurement) {
        let viewModel = FurnituresViewModel(measurement: measurement,useCase: _furnitureUseCase)
        let viewController = FurnituresViewController.create(with: self, viewModel: viewModel)
        _navigationController.pushViewController(viewController, animated: true)
    }
    
    func showNewFurniture(measurement: Measurement) {
        let viewModel = NewFurnitureViewModel(measurement: measurement, useCase: _furnitureUseCase)
        let navigator = DefaultCalculatorNavigator(navigationController: _navigationController)
        let viewController = NewFurnitureTableViewController.create(with: navigator, viewModel: viewModel)
        _navigationController.pushViewController(viewController, animated: true)
    }
    
    func showSummary(furniture: Furniture) {
        let viewModel = SummaryViewModel(furniture: furniture, useCase: _componentUseCase)
        let navigator = DefaultCalculatorNavigator(navigationController: _navigationController)
        let vc = SummaryViewController.create(with: navigator, viewModel: viewModel)
        _navigationController.pushViewController(vc, animated: true)
    }
}
