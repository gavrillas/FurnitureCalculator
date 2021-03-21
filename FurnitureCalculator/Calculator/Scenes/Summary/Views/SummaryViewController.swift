//
//  SummeryViewController.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 19..
//  Copyright © 2021. kristof. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class SummaryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self._bindViewModel()
        }
        
        title = _viewModel.controllerTitle
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _viewModel.reloadData()
    }
    
    private let _disposeBag = DisposeBag()
    private var _navigator: CalculatorNavigator!
    private var _viewModel: SummaryViewModel!
    
    static func create(with naviagator: CalculatorNavigator, viewModel: SummaryViewModel) -> SummaryViewController {
        let vc = Storyboards.load(storyboard: .calculator, type: self)
        vc._navigator = naviagator
        vc._viewModel = viewModel
        return vc
    }
    
    private func _bindViewModel() {
        let selectComponent = tableView.rx.itemSelected.asObservable()
        let addComponent = addButton.rx.tap.asObservable()
        let input = SummaryViewModel.Input(selectComponent: selectComponent,
                                           addComponent: addComponent)
        
        let output = _viewModel.transform(input: input)
        
        output.tableData
            .drive(tableView.rx.items(dataSource: _dataSource))
            .disposed(by: _disposeBag)
        
        output.openCalculator.drive(onNext: { [unowned self] (furniture, component) in
            guard let comp = component else { return }
            switch comp.componentType {
            case .Upper:
                self._navigator.showUpperCalc(furniture: furniture, component: comp)
            case .Lower:
                self._navigator.showLowerCalc(furniture: furniture, component: comp)
            case .Tower:
                self._navigator.showTowerCalc(furniture: furniture, component: comp)
            case .Gardrobe:
                self._navigator.showGardrobeCalc(furniture: furniture, component: comp)
            case .Other:
                self._navigator.showOtherCalc(furniture: furniture, component: comp)
            default:
                return
            }
        }).disposed(by: _disposeBag)
        
        output.addComponent.drive(onNext: { [unowned self] furniture in
            switch furniture.type {
            case .Kitchen:
                self._navigator.showKitchen(furniture: furniture)
            case .Gardrobe:
                self._navigator.showGardrobeCalc(furniture: furniture, component: nil)
            case .Other:
                self._navigator.showOtherCalc(furniture: furniture, component: nil)
            }
            
        }).disposed(by: _disposeBag)
        
        tableView.rx.itemDeleted
            .subscribe(onNext: { [unowned self] ip in
                self._viewModel.deleteComponent(ip: ip)
            }).disposed(by: _disposeBag)
    }
}

extension SummaryViewController {
    private var _dataSource: RxTableViewSectionedAnimatedDataSource<SummaryViewModel.SectionModel> {
        let dataSource = RxTableViewSectionedAnimatedDataSource<SummaryViewModel.SectionModel>(
            decideViewTransition: { _, _, changeSet in changeSet.isEmpty ? .reload : .animated },
            configureCell: { ds, tv, ip, _ in
                switch ds[ip] {
                case let .summary(viewModel):
                    let cell = tv.dequeueReusableCell(withIdentifier: "SummaryCell", for: ip) as! SummaryCell
                    cell.config(with: viewModel)
                    return cell
                case let .component(component):
                    let cell = tv.dequeueReusableCell(withIdentifier: "ComponentCell", for: ip) as! ComponentCell
                    cell.config(component: component)
                    return cell
                }
            })
        
        dataSource.titleForHeaderInSection = { ds, index in
            ds.sectionModels[index].header
        }
        
        dataSource.canEditRowAtIndexPath = { ds, index in
            index.section > 0
        }
        
        return dataSource
    }
}

extension SummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
         //For Header Background Color
        view.tintColor = UIColor.lightBrown
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
         dismissKeyboard()
    }
}
