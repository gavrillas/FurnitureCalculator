//
//  SummaryViewModel.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 19..
//  Copyright © 2021. kristof. All rights reserved.
//

import RxSwift
import RxDataSources
import struct RxCocoa.Driver

struct SummaryViewModel: ViewModelType {
    struct SectionModel {
        let identity: Int
        let header: String
        var items: [SectionItem]
    }
    
    enum SectionItem {
        case summary(viewModel: SummaryCellViewModel)
        case component(component: Component)
    }
    
    enum Section: Int {
        case summary
        case components
    }
    
    struct Input {
        let selectComponent: Observable<IndexPath>
        let addComponent: Observable<Void>
    }
    
    struct Output {
        let tableData: Driver<[SectionModel]>
        let openCalculator: Driver<(Furniture,Component?)>
        let addComponent: Driver<Furniture>
    }
    
    public var controllerTitle: String {
        _furniture.Name
    }
    
    private let _furniture: Furniture
    private let _useCase: ComponentUseCase
    private let _sectionListSubject = BehaviorSubject(value: [SectionModel]())
    
    private var _sections: Observable<[SectionModel]> {
        _sectionListSubject.asObservable()
    }
    
    private var _sectionElements: [SectionModel] {
        var sections = [SectionModel]()
        let viewModel = SummaryCellViewModel(furniture: _furniture,
                                             useCase: FurnitureRepository.make())
        sections.append(SectionModel(identity: Section.summary.rawValue,
                                     header: "Összegzés",
                                     items: [SectionItem.summary(viewModel: viewModel)]))
        var items = [SectionItem]()
        _furniture.Components.forEach {
            items.append(SectionItem.component(component: $0))
        }
        sections.append(SectionModel(identity: Section.components.rawValue,
                                     header: "A bútor részei",
                                     items: items))
        return sections
    }
    
    init(furniture: Furniture, useCase: ComponentUseCase) {
        _furniture = furniture
        _useCase = useCase
    }
    
    public func transform(input: Input) -> Output {
        let tableData = _sections.asDriver(onErrorJustReturn: [])
        
        reloadData()
        
        let openCalculator = input.selectComponent.map { ip -> (Furniture, Component?) in
            let component = ip.section > 0 ? _furniture.Components[ip.row] : nil
            return (_furniture, component)
        }.asDriver(onErrorJustReturn: (_furniture, nil))
        
        let addComponent = input.addComponent.map {
            _furniture
        }.asDriver(onErrorJustReturn: _furniture)
        
        return Output(tableData: tableData,
                      openCalculator: openCalculator,
                      addComponent: addComponent)
    }
    
    public func reloadData() {
        _sectionListSubject.onNext(_sectionElements)
    }
    
    public func deleteComponent(ip: IndexPath) {
        _useCase.deleteComponent(component: _furniture.Components[ip.row])
        reloadData()
    }
}

extension SummaryViewModel.SectionModel: AnimatableSectionModelType {
    typealias Identity = Int
    typealias Item = SummaryViewModel.SectionItem
    
    init(original: SummaryViewModel.SectionModel, items: [SummaryViewModel.SectionItem]) {
        self = original
        self.items = items
    }
}

extension SummaryViewModel.SectionItem: IdentifiableType {
    typealias Identity = Int

    var identity: Int {
        switch self {
        case .summary:
            return SummaryViewModel.Section.summary.rawValue
        case .component:
            return SummaryViewModel.Section.components.rawValue
        }
    }
}

extension SummaryViewModel.SectionItem: Equatable {
    static func ==(lhs: SummaryViewModel.SectionItem, rhs: SummaryViewModel.SectionItem) -> Bool {
        lhs.identity == rhs.identity
    }
}
