//
//  FurnituresViewController.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 08..
//  Copyright © 2021. kristof. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class FurnituresViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    private let _disposeBag = DisposeBag()
    private var _viewModel: FurnituresViewModel!
    private var _navigator: HomeNavigator!

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self._bindViewModel()
         }
        
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _viewModel.reloadData()
    }
    
    static func create(with navigator: HomeNavigator, viewModel: FurnituresViewModel) -> FurnituresViewController {
        let vc = Storyboards.load(storyboard: .main, type: self)
        vc._viewModel = viewModel
        vc._navigator = navigator
        return vc
    }
    
    private func _bindViewModel() {
        
        let addNewFurniture = addButton.rx.tap.asObservable()
        
        let select = tableView.rx.itemSelected.asObservable()
        
        let input = FurnituresViewModel.Input(addNewFurniture: addNewFurniture,
                                              selectFurniture: select)
        
        let output = _viewModel.transform(input: input)
        
        output.tableData
            .drive(tableView.rx.items(dataSource: _dataSource))
            .disposed(by: _disposeBag)
        
        output.addFurniture.drive(onNext: { [unowned self] measurement in
            self._navigator.showNewFurniture(measurement: measurement)
        }).disposed(by: _disposeBag)
        
        output.openFurnitureSummary.drive(onNext: { [unowned self] furniture in
            self._navigator.showSummary(furniture: furniture)
        }).disposed(by: _disposeBag)
        
        tableView.rx.itemDeleted
            .subscribe(onNext: { [unowned self] ip in
                self._viewModel.deleteFurniture(ip: ip)
        }).disposed(by: _disposeBag)
    }
}

extension FurnituresViewController {
    private var _dataSource: RxTableViewSectionedReloadDataSource<FurnituresViewModel.SectionModel> {
        let dataSource = RxTableViewSectionedReloadDataSource<FurnituresViewModel.SectionModel>(configureCell: { ds, tv, ip, furniture in
            let cell = tv.dequeueReusableCell(withIdentifier: "FurnitureCell", for: ip) as! FurnitureCell
            cell.config(furniture: furniture)
            return cell
        })
        
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath  in
            return true
        }
        
        dataSource.titleForHeaderInSection = { ds, index in
            if !ds.sectionModels[index].items.isEmpty {
                return ds.sectionModels[index].header
            }
            return nil
        }
        
        return dataSource
    }
}

extension FurnituresViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
         //For Header Background Color
        view.tintColor = UIColor.lightBrown
    }
}
