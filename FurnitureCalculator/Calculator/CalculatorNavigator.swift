//
//  KitchenNavigator.swift
//  FurnitureCalculator
//
//  Created by kristof on 2020. 12. 19..
//  Copyright © 2020. kristof. All rights reserved.
//

import UIKit

protocol CalculatorNavigator {
    func showUpperCalc(furniture: Furniture, component: Component?)
    func showLowerCalc(furniture: Furniture, component: Component?)
    func showTowerCalc(furniture: Furniture, component: Component?)
    func showGardrobeCalc(furniture: Furniture, component: Component?)
    func showOtherCalc(furniture: Furniture, component: Component?)
    func showKitchen(furniture: Furniture)
    func showSummary(furniture: Furniture)
}

final class DefaultCalculatorNavigator: CalculatorNavigator {
    private weak var _navigationController: UINavigationController!
    
    private let _componentUseCase = ComponentRepository.make()

    init(navigationController: UINavigationController) {
        _navigationController = navigationController
    }
    
    func showUpperCalc(furniture: Furniture, component: Component? = nil) {
        let viewModel = UpperViewModel(furniture: furniture, component: component, useCase: _componentUseCase)
        let vc = CalculatorViewController.create(with: self, viewModel: viewModel)
        _navigationController.pushViewController(vc, animated: true)
    }
    
    func showLowerCalc(furniture: Furniture, component: Component? = nil) {
        let viewModel = LowerViewModel(furniture: furniture, component: component, useCase: _componentUseCase)
        let vc = CalculatorViewController.create(with: self, viewModel: viewModel)
        _navigationController.pushViewController(vc, animated: true)
    }
    
    func showTowerCalc(furniture: Furniture, component: Component? = nil) {
        let viewModel = TowerViewModel(furniture: furniture, component: component, useCase: _componentUseCase)
        let vc = CalculatorViewController.create(with: self, viewModel: viewModel)
        _navigationController.pushViewController(vc, animated: true)
    }
    
    func showGardrobeCalc(furniture: Furniture, component: Component? = nil) {
        let viewModel = GardrobeViewModel(furniture: furniture, component: component, useCase: _componentUseCase)
        let vc = CalculatorViewController.create(with: self, viewModel: viewModel)
        _navigationController.pushViewController(vc, animated: true)
    }
    
    func showOtherCalc(furniture: Furniture, component: Component? = nil) {
        let viewModel = OtherViewModel(furniture: furniture, component: component, useCase: _componentUseCase)
        let vc = CalculatorViewController.create(with: self, viewModel: viewModel)
        _navigationController.pushViewController(vc, animated: true)
    }
    
    func showKitchen(furniture: Furniture) {
        let vc = KitchenTableViewController.create(with: self, furniture: furniture)
        _navigationController.pushViewController(vc, animated: true)
    }
    
    func showSummary(furniture: Furniture) {
        let viewModel = SummaryViewModel(furniture: furniture, useCase: _componentUseCase)
        let vc = SummaryViewController.create(with: self, viewModel: viewModel)
        _navigationController.pushViewController(vc, animated: true)
    }
}
