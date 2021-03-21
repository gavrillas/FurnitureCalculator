//
//  PreviousMeasurementsViewController.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 06..
//  Copyright © 2021. kristof. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class PreviousMeasurementsViewController: UIViewController {
    @IBOutlet weak var measurementsTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    private let _disposeBag = DisposeBag()
    private let _viewModel = PreviousMeasurementsViewModel()
    private var _navigator: HomeNavigator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let nc = self.navigationController else { return }
        self._navigator = DefaultHomeNavigator(navigationController: nc )
        self._bindViewModel()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func _bindViewModel() {
        let add = addButton.rx.tap.asObservable()
        let select = measurementsTableView.rx.itemSelected.asObservable()
        
        let input = PreviousMeasurementsViewModel.Input(addNew: add, select: select)
        let output = _viewModel.transform(input: input)
        
        output.tableData
            .drive(measurementsTableView.rx.items(dataSource: _dataSource))
            .disposed(by: _disposeBag)
        
        output.showAlert.drive(onNext: { [unowned self] alert in
            self.present(alert, animated: true)
        }).disposed(by: _disposeBag)
        
        output.openMeasurement.drive(onNext: { [unowned self] measurement in
            self._navigator.showFurnitures(measurement: measurement)
        }).disposed(by: _disposeBag)
        
        measurementsTableView.rx.itemDeleted
            .subscribe(onNext: { [unowned self] ip in
                self._viewModel.deleteMeasurement(ip: ip)
            }).disposed(by: _disposeBag)
    }
    
}

extension PreviousMeasurementsViewController {
    private var _dataSource: RxTableViewSectionedReloadDataSource<PreviousMeasurementsViewModel.SectionModel>{
        let dataSource = RxTableViewSectionedReloadDataSource<PreviousMeasurementsViewModel.SectionModel>(configureCell: { ds, tv, ip, measurement in
            let cell = tv.dequeueReusableCell(withIdentifier: "MeasurementCell", for: ip) as! MeasurementCell
            cell.config(measurement: measurement)
            return cell
        })
        
        dataSource.canEditRowAtIndexPath = { dataSource, indexPath  in
            return true
        }
        
        return dataSource
    }
}
