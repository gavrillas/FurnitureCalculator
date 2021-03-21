//
//  HomeTableViewController.swift
//  FurnitureCalculator
//
//  Created by kristof on 2020. 01. 29..
//  Copyright © 2020. kristof. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class NewFurnitureTableViewController: UITableViewController {
    
    private let _disposeBag = DisposeBag()
    private var _navigator: CalculatorNavigator!
    private var _viewModel: NewFurnitureViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _bindSelection()
    }
    
    static func create(with navigator: CalculatorNavigator, viewModel: NewFurnitureViewModel) -> NewFurnitureTableViewController {
        let vc = Storyboards.load(storyboard: .main, type: self)
        vc._navigator = navigator
        vc._viewModel = viewModel
        return vc
    }

    private func _bindSelection() {
        tableView.rx.itemSelected.subscribe(onNext: {[unowned self] in
            let type = FurnitureType.init(rawValue: $0.row) ?? .Kitchen
            self.present(_createAlert(type: type), animated: true)
            }).disposed(by: _disposeBag)
    }
    
    private func _createAlert(type: FurnitureType) -> UIAlertController {
        let alert = UIAlertController(title: "Bútor neve", message: "Adj egy nevet a bútornak", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Mégse", style: .cancel))
        alert.addAction(UIAlertAction(title: "Mentés", style: .default, handler: { [unowned self] _ in
            let name = alert.textFields?.first?.text ?? ""
            let furniture = self._viewModel.saveFurniture(name: name, type: type)
            switch type {
            case .Kitchen:
                self._navigator.showKitchen(furniture: furniture)
            case .Gardrobe:
                self._navigator.showGardrobeCalc(furniture: furniture, component: nil)
            case .Other:
                self._navigator.showGardrobeCalc(furniture: furniture, component: nil)
            }
        }))
        return alert
    }
    
}
