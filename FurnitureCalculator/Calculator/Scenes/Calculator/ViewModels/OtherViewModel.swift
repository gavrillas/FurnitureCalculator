//
//  OtherViewModel.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 02. 20..
//  Copyright © 2021. kristof. All rights reserved.
//

import RxSwift

struct OtherViewModel: CalculatorViewModel {
    let furniture: Furniture
    let useCase: ComponentUseCase
    let resultViewModels: [FurnitureBoardCellViewModel]
    let parameterViewModels: [ParameterCellViewModel]
    let input: CalculatorInput
    let storedComponent: BehaviorSubject<Component?>
    let componentType: Component.ComponentType = .Other
    
    init(furniture: Furniture, component: Component?, useCase: ComponentUseCase) {
        self.furniture = furniture
        storedComponent = BehaviorSubject<Component?>(value: component)
        self.useCase = useCase
        
        input = CalculatorInput(type: componentType, component: component)
        
        parameterViewModels = [ParameterCellViewModel(name: "Név",
                                                      value: input.nameField,
                                                      keyboard: .default),
                               ParameterCellViewModel(name: "Magasság",
                                                      value: input.heightField,
                                                      keyboard: .numberPad),
                               ParameterCellViewModel(name: "Szélesség",
                                                      value: input.widthField,
                                                      keyboard: .numberPad),
                               ParameterCellViewModel(name: "Mélység",
                                                      value: input.depthField,
                                                      keyboard: .numberPad),
                               ParameterCellViewModel(name: "Polc",
                                                      value: input.shelfsField,
                                                      keyboard: .numberPad),
                               ParameterCellViewModel(name: "Ajtó",
                                                      value: input.doorsField,
                                                      keyboard: .numberPad),
                               ParameterCellViewModel(name: "Válaszfalak száma",
                                                      value: input.partitionWallsField,
                                                      keyboard: .numberPad),
                               ParameterCellViewModel(name: "Fiókok száma",
                                                      value: input.drawersQuantityField,
                                                      keyboard: .numberPad),
                               ParameterCellViewModel(name: "Fiókok magassága",
                                                      value: input.drawerHeightField,
                                                      keyboard: .numberPad),]
        
        
        
        var savedBoards: [FurnitureBoard]? = nil
        if let boards = component?.FurnitureBoards {
            savedBoards = Array(boards)
        }
        
        resultViewModels = [EntireTopBottomViewModel(input: input, boardName: "Tető", savedBoards: savedBoards),
                            EntireTopBottomViewModel(input: input, boardName: "Fenék", savedBoards: savedBoards),
                             GardrobeSideViewModel(input: input, boardName: "Oldal", savedBoards: savedBoards),
                             GardrobeShelfViewModel(input: input, boardName: "Polc", savedBoards: savedBoards),
                             HDFViewModel(input: input, boardName: "HDF", savedBoards: savedBoards),
                             GardrobePartionWallViewModel(input: input, boardName: "Válaszfal", savedBoards: savedBoards),]
    }
}
