//
//  KitchenViewController.swift
//  FurnitureCalculator
//
//  Created by kristof on 2020. 01. 29..
//  Copyright © 2020. kristof. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class KitchenTableViewController: UITableViewController {
    
    private let _disposeBag = DisposeBag()
    private var _navigator: CalculatorNavigator!
    private var _furniture: Furniture!

    override func viewDidLoad() {
        super.viewDidLoad()
        _bindSelection()
    }
    
    static func create(with navigator: CalculatorNavigator, furniture: Furniture) -> KitchenTableViewController {
        let vc = Storyboards.load(storyboard: .calculator, type: KitchenTableViewController.self)
        vc._navigator = navigator
        vc._furniture = furniture
        return vc
    }
    
    private func _bindSelection() {
        tableView.rx.itemSelected.subscribe(onNext: {[unowned self] in
            guard let navigator = self._navigator else { return }
            switch $0.row {
            case 0:
                navigator.showUpperCalc(furniture: _furniture, component: nil)
            case 1:
                navigator.showLowerCalc(furniture: _furniture, component: nil)
            case 2:
                navigator.showTowerCalc(furniture: _furniture, component: nil)
            default:
                print("asd")
            }
            }).disposed(by: _disposeBag)
    }
}
