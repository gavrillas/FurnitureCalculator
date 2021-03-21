//
//  CalculatorViewController.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 02. 10..
//  Copyright © 2021. kristof. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class CalculatorViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _bindViewModel()
        
        setUpDismissKeyboard()
        
        tableView.delegate = self
    }
    
    private let _disposeBag = DisposeBag()
    private var _navigator: CalculatorNavigator!
    private var _viewModel: CalculatorViewModel!
    
    static func create(with naviagator: CalculatorNavigator, viewModel: CalculatorViewModel) -> CalculatorViewController {
        let vc = Storyboards.load(storyboard: .calculator, type: self)
        vc._navigator = naviagator
        vc._viewModel = viewModel
        return vc
    }
    
    private func _bindViewModel() {
        let output = _viewModel.transform()
        
        output.tableData
            .drive(tableView.rx.items(dataSource: _dataSource))
            .disposed(by: _disposeBag)
        
        output.screenName
            .drive(rx.title)
            .disposed(by: _disposeBag)
        
        output.save
            .drive(onNext: { [unowned self] in
                self._showAlert()
            }).disposed(by: _disposeBag)
    }
    
    private func _showAlert() {
        let alert = UIAlertController(title: "Sikeres mentés", message: nil, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        UIView.animate(withDuration: 1, animations: { () -> Void in
            alert.dismiss(animated: true)
        })
    }
}

extension CalculatorViewController {
    private var _dataSource: RxTableViewSectionedAnimatedDataSource<CalculatorSectionModel> {
        let dataSource = RxTableViewSectionedAnimatedDataSource<CalculatorSectionModel>(
            decideViewTransition: { _, _, changeSet in changeSet.isEmpty ? .reload : .animated },
            configureCell: { ds, tv, ip, _ in
                switch ds[ip] {
                case let .parameter(parameter):
                    let cell = tv.dequeueReusableCell(withIdentifier: "ParameterCell", for: ip) as! ParameterCell
                    cell.config(with: parameter)
                    return cell
                case let .result(viewModel):
                    let cell = tv.dequeueReusableCell(withIdentifier: "FurnitureBoardCell", for: ip) as! FurnitureBoardCell
                    cell.config(with: viewModel)
                    return cell
                case let .save(viewModel):
                    let cell = tv.dequeueReusableCell(withIdentifier: "SaveComponentCell", for: ip) as! SaveComponentCell
                    cell.config(with: viewModel)
                    return cell
                }
            })
        
        dataSource.titleForHeaderInSection = { ds, index in
            ds.sectionModels[index].header
        }
        
        return dataSource
    }
}

extension CalculatorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
         //For Header Background Color
        view.tintColor = UIColor.lightBrown
    }
}
