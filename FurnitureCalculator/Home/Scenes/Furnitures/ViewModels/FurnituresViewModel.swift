//
//  FurnituresViewModel.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 08..
//  Copyright © 2021. kristof. All rights reserved.
//

import RxSwift
import struct RxCocoa.Driver
import RxDataSources

struct FurnituresViewModel: ViewModelType {
    struct SectionModel {
        var header: String
        var items: [Furniture]
    }
    
    struct Input {
        let addNewFurniture: Observable<Void>
        let selectFurniture: Observable<IndexPath>
    }
    
    struct Output {
        let tableData: Driver<[SectionModel]>
        let addFurniture: Driver<Measurement>
        let openFurnitureSummary: Driver<Furniture>
    }
    
    private let _measurement: Measurement
    private let _useCase: FurnitureUseCase
    private let _sectionListSubject = BehaviorSubject(value: [SectionModel]())
    
    private var _sections: Observable<[SectionModel]> {
        _sectionListSubject.asObservable()
    }
    
    private var _kitchens: [Furniture] {
        Array(_measurement.Kitchen)
    }
    
    private var _gardrobes: [Furniture] {
        Array(_measurement.Gardrobe)
    }
    
    private var _others: [Furniture] {
        Array(_measurement.Others)
    }
    
    private var _sectionElements: [SectionModel] {
        var sections = [SectionModel]()
        sections.append(SectionModel(header: "Konyha", items: _kitchens))
        
        sections.append(SectionModel(header: "Gardrób", items: _gardrobes))
        
        sections.append(SectionModel(header: "Egyéb", items: _others))

        return sections
    }
    
    init(measurement: Measurement, useCase: FurnitureUseCase) {
        self._measurement = measurement
        self._useCase = useCase
    }
    
    public func transform(input: Input) -> Output {
        let tableData = _sections.asDriver(onErrorJustReturn: [])
        
        reloadData()
        
        let addFurniture = input.addNewFurniture.map {
            _measurement
        }.asDriver(onErrorJustReturn: _measurement)
        
        let openFurnitureSummary = input.selectFurniture.map { ip in
            guard let furnitureType = FurnitureType.init(rawValue: ip.section) else { return  Furniture()}
            
            switch furnitureType {
            case .Kitchen:
                return _kitchens[ip.row]
            case .Gardrobe:
                return _gardrobes[ip.row]
            case .Other:
                return _others[ip.row]
            }
        }.asDriver(onErrorJustReturn: Furniture())
        
        let output = Output(tableData: tableData,
                            addFurniture: addFurniture,
                            openFurnitureSummary: openFurnitureSummary)
        
        return output
    }
    
    public func reloadData() {
        _sectionListSubject.onNext(_sectionElements)
    }
    
    public func deleteFurniture(ip: IndexPath) {
        guard let furnitureType = FurnitureType.init(rawValue: ip.section) else { return }
        switch furnitureType {
        case .Kitchen:
            _useCase.deleteFurniture(furniture: _kitchens[ip.row])
        case .Gardrobe:
            _useCase.deleteFurniture(furniture: _gardrobes[ip.row])
        case .Other:
            _useCase.deleteFurniture(furniture: _others[ip.row])
        }
        reloadData()
    }
}

extension FurnituresViewModel.SectionModel: SectionModelType {
    typealias Item = Furniture

    init(original: FurnituresViewModel.SectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
