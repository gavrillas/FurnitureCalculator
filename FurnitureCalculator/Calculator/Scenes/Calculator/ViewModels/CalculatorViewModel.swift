//
//  CalculatorViewModel.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 02. 10..
//  Copyright © 2021. kristof. All rights reserved.
//

import RxSwift
import RxDataSources
import struct RxCocoa.Driver
import class RxCocoa.BehaviorRelay

struct CalculatorInput {
    let nameField: BehaviorRelay<String>
    let heightField: BehaviorRelay<String>
    let widthField: BehaviorRelay<String>
    let depthField: BehaviorRelay<String>
    let shelfsField: BehaviorRelay<String>
    let doorsField: BehaviorRelay<String>
    let partitionWallsField: BehaviorRelay<String>
    let drawersQuantityField: BehaviorRelay<String>
    let drawerHeightField: BehaviorRelay<String>
    let smallDrawersQuantityField: BehaviorRelay<String>
    let smallDrawerHeightField: BehaviorRelay<String>
    let save = PublishSubject<Void>()
    let componentType: Component.ComponentType
    
    var height: Observable<Double> {
        heightField.map { Double($0.replacingOccurrences(of: ",", with: ".")) ?? 0 }.asObservable()
    }
    
    var width: Observable<Double> {
        widthField.map { Double($0.replacingOccurrences(of: ",", with: ".")) ?? 0 }.asObservable()
    }
    
    var depth: Observable<Double> {
        depthField.map { Double($0.replacingOccurrences(of: ",", with: ".")) ?? 0 }.asObservable()
    }
    
    var shelf: Observable<Int> {
        shelfsField.map { Int($0) ?? 0 }.asObservable()
    }
    var door: Observable<Int> {
        doorsField.map { Int($0) ?? 0 }.asObservable()
    }
    
    var partitionWall: Observable<Int> {
        partitionWallsField.map { Int($0) ?? 0 }.asObservable()
    }
    
    var drawersQuantity: Observable<Int> {
        drawersQuantityField.map { Int($0) ?? 0 }.asObservable()
    }
    
    var drawerHeight: Observable<Double> {
        drawerHeightField.map { Double($0.replacingOccurrences(of: ",", with: ".")) ?? 0 }.asObservable()
    }
    
    var smallDrawersQuantity: Observable<Int> {
        smallDrawersQuantityField.map { Int($0) ?? 0 }.asObservable()
    }
    
    var smallDrawerHeight: Observable<Double> {
        smallDrawerHeightField.map { Double($0.replacingOccurrences(of: ",", with: ".")) ?? 0 }.asObservable()
    }
    
    init(type: Component.ComponentType, component: Component?) {
        nameField = BehaviorRelay<String>(value: component?.Name ?? type.rawValue)
        heightField = BehaviorRelay<String>(value: String(component?.Height ?? 120))
        widthField = BehaviorRelay<String>(value: String(component?.Width ?? 60))
        depthField = BehaviorRelay<String>(value: String(component?.Depth ?? 40))
        shelfsField = BehaviorRelay<String>(value: String(component?.Shelf ?? 0))
        doorsField = BehaviorRelay<String>(value: String(component?.Door ?? 0))
        partitionWallsField = BehaviorRelay<String>(value: String(component?.PartitionWalls ?? 0))
        drawersQuantityField = BehaviorRelay<String>(value: String(component?.DrawersQuantity ?? 0))
        drawerHeightField = BehaviorRelay<String>(value: String(component?.DrawersHeight ?? 0))
        smallDrawersQuantityField = BehaviorRelay<String>(value: String(component?.SmallDrawersQuantity ?? 0))
        smallDrawerHeightField = BehaviorRelay<String>(value: String(component?.SmallDrawersHeight ?? 0))
        componentType = type
    }
}

struct CalculatorSectionModel {
    let identity: Int
    let header: String
    var items: [CalculatorSectionItem]
}

enum CalculatorSectionItem {
    case parameter(viewModel: ParameterCellViewModel)
    case result(viewModel: FurnitureBoardCellViewModel)
    case save(viewModel: SaveComponentCellViewModel)
}

enum CalculatorSection: Int {
    case parameter
    case result
    case save
}

struct CalculatorOutput {
    let tableData: Driver<[CalculatorSectionModel]>
    let screenName: Driver<String>
    let save: Driver<Void>
}

protocol CalculatorViewModel {
    var furniture: Furniture { get }
    var useCase: ComponentUseCase { get }
    var resultViewModels: [FurnitureBoardCellViewModel] { get }
    var parameterViewModels: [ParameterCellViewModel] { get }
    var input: CalculatorInput { get }
    var storedComponent: BehaviorSubject<Component?> { get }
    var componentType: Component.ComponentType { get }
    
    init(furniture: Furniture, component: Component?, useCase: ComponentUseCase)
}

extension CalculatorViewModel {
    private var _sectionElements: [CalculatorSectionModel] {
        var sections = [CalculatorSectionModel]()
        
        let parameterItems = parameterViewModels.map { CalculatorSectionItem.parameter(viewModel: $0) }
        
        sections.append(CalculatorSectionModel(identity: CalculatorSection.parameter.rawValue,
                                     header: "Paraméterek",
                                     items: parameterItems))
        
        
        let resultItems = resultViewModels.map { CalculatorSectionItem.result(viewModel: $0) }
        
        sections.append(CalculatorSectionModel(identity: CalculatorSection.result.rawValue,
                                     header: "Eredmény",
                                     items: resultItems))
        let save = [CalculatorSectionItem.save(viewModel: SaveComponentCellViewModel(save: input.save))]
        
        sections.append(CalculatorSectionModel(identity: CalculatorSection.save.rawValue,
                                     header: "",
                                     items: save))
        
        return sections
    }
    
    public func transform() -> CalculatorOutput {
        let tableData = Observable.from(optional: _sectionElements)
            .asDriver(onErrorJustReturn: [])
        
        let screenName = input.nameField.asDriver(onErrorJustReturn: "")
        
        let furnitureBoards = Observable
            .combineLatest(resultViewModels.map { $0.furnitureBoard })
        
        let drawerInputs = Observable
            .combineLatest(input.smallDrawersQuantity,
                           input.smallDrawerHeight,
                           input.drawersQuantity,
                           input.drawerHeight)
        
        let sizeInputs = Observable
            .combineLatest(input.width,
                           input.height,
                           input.depth)
        
        let otherInputs = Observable
            .combineLatest(input.nameField,
                           input.shelf,
                           input.door,
                           input.partitionWall)
        
        let component = Observable
            .combineLatest(sizeInputs,
                           otherInputs,
                           drawerInputs,
                           furnitureBoards)
            .map { size, others, drawers, boards -> Component in
                let (width, height, depth) = size
                let (name, shelf, door, partitionalWalls) = others
                let (smallDrawersQuantity, smallDrawersHeight, drawersQuantity, drawerHeight) = drawers
                return Component(name: name,
                                 width: width,
                                 height: height,
                                 depth: depth,
                                 shelf: shelf,
                                 door: door,
                                 partitionalWalls: partitionalWalls,
                                 drawersQuantity: drawersQuantity,
                                 drawersHeight: drawerHeight,
                                 smallDrawersQuantity: smallDrawersQuantity,
                                 smallDrawerHeight: smallDrawersHeight,
                                 type: componentType,
                                 boards: boards)
            }
        
        let save = input.save
            .withLatestFrom(Observable.combineLatest(component, storedComponent))
            .map { component, savedComponent in
                saveComponent(component: component, savedComponent: savedComponent)
        }.asDriver(onErrorJustReturn: ())
        
        return CalculatorOutput(tableData: tableData,
                      screenName: screenName,
                      save: save)
    }
    
    func saveComponent(component: Component, savedComponent: Component?) {
        if let saved = savedComponent {
            useCase.updateComponent(savedComponent: saved, newComponent: component)
        } else {
            useCase.saveComponent(furniture: furniture, component: component)
            storedComponent.onNext(component)
        }
    }
}

extension CalculatorSectionModel: AnimatableSectionModelType {
    typealias Identity = Int
    typealias Item = CalculatorSectionItem
    
    init(original: CalculatorSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

extension CalculatorSectionItem: IdentifiableType {
    typealias Identity = Int

    var identity: Int {
        switch self {
        case .parameter:
            return CalculatorSection.parameter.rawValue
        case .result:
            return CalculatorSection.result.rawValue
        case .save:
            return CalculatorSection.save.rawValue
        }
    }
}

extension CalculatorSectionItem: Equatable {
    static func ==(lhs: CalculatorSectionItem, rhs: CalculatorSectionItem) -> Bool {
        lhs.identity == rhs.identity
    }
}
