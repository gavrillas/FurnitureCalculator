//
//  PreviousMeasurementsViewModel.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 07..
//  Copyright © 2021. kristof. All rights reserved.
//

import RxSwift
import struct RxCocoa.Driver
import RxDataSources

struct PreviousMeasurementsViewModel: ViewModelType

{
    struct SectionModel {
        var items:[Measurement]
    }
    
    struct Input {
        let addNew: Observable<Void>
        let select: Observable<IndexPath>
    }
    
    struct Output {
        let tableData:Driver<[SectionModel]>
        let showAlert: Driver<UIAlertController>
        let openMeasurement: Driver<Measurement>
    }
 
    private let _useCase: MeasurementUseCase = MeasurementRepository.make()
    private let _sectionListSubject = BehaviorSubject(value: [SectionModel]())

    private var _sections: Observable<[SectionModel]> {
        _sectionListSubject.asObservable()
    }
    
    private var _sortedMeasurements: [Measurement] {
        _useCase.measurements.sorted {
            $0.Name < $1.Name
        }
    }
    
    public func transform(input: Input) -> Output {
        let showAlert = input.addNew.map({ _ in
            _createAlert()
        }).asDriver(onErrorJustReturn: UIAlertController(title: "Felmérés neve", message: "Adj egy nevet a felmérésnek", preferredStyle: .alert))
        
        let tableData = _sections.asDriver(onErrorJustReturn: [])
        
        reloadData()
        
        let openMeasurement = input.select.map { ip in
            _sortedMeasurements[ip.row]
        }.asDriver(onErrorJustReturn: Measurement())
        
        return Output(tableData: tableData,
                      showAlert: showAlert,
                      openMeasurement: openMeasurement)
    }
    
    public func reloadData() {
        _sectionListSubject.onNext([SectionModel(items: _sortedMeasurements)])
    }
    
    public func deleteMeasurement(ip: IndexPath) {
        _useCase.deleteMeasurement(measurement: _sortedMeasurements[ip.row])
        reloadData()
    }
    
    private func _createAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Felmérés neve", message: "Adj egy nevet a felmérésnek", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Mégse", style: .cancel))
        alert.addAction(UIAlertAction(title: "Mentés", style: .default, handler: { _ in
            let measurement = Measurement()
            measurement.Name = alert.textFields?.first?.text ?? ""
            _useCase.saveMeasurement(measurement: measurement)
            _sectionListSubject.onNext([SectionModel(items: _sortedMeasurements)])
        }))
        return alert
    }
}

extension PreviousMeasurementsViewModel.SectionModel: SectionModelType {
    typealias Item = Measurement

    init(original: PreviousMeasurementsViewModel.SectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
