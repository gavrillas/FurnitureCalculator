//
//  LowerViewModel.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 02. 15..
//  Copyright © 2021. kristof. All rights reserved.
//

import RxSwift

struct LowerViewModel: CalculatorViewModel {
    let furniture: Furniture
    let useCase: ComponentUseCase
    let resultViewModels: [FurnitureBoardCellViewModel]
    let parameterViewModels: [ParameterCellViewModel]
    let input: CalculatorInput
    let storedComponent: BehaviorSubject<Component?>
    let componentType: Component.ComponentType = .Lower
    
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
                               ParameterCellViewModel(name: "Kis fiókok száma",
                                                      value: input.smallDrawersQuantityField,
                                                      keyboard: .numberPad),
                               ParameterCellViewModel(name: "Nagy fiókok száma",
                                                      value: input.drawersQuantityField,
                                                      keyboard: .numberPad),
                               ParameterCellViewModel(name: "Kis fiókelő magassága",
                                                      value: input.smallDrawerHeightField,
                                                      keyboard: .numberPad)]
        
        
        
        var boards: [FurnitureBoard]? = nil
        if let savedBoards = component?.FurnitureBoards {
            boards = Array(savedBoards)
        }
        
        resultViewModels = [LowerConnectorViewModel(input: input, boardName: "Összekötő", savedBoards: boards),
                            EntireTopBottomViewModel(input: input, boardName: "Fenék", savedBoards: boards),
                            LowerSideViewModel(input: input, boardName: "Oldal", savedBoards: boards),
                             ShelfViewModel(input: input, boardName: "Polc", savedBoards: boards),
                             LowerDoorViewModel(input: input, boardName: "Ajtó", savedBoards: boards),
                             LowerHDFViewModel(input: input, boardName: "HDF", savedBoards: boards),
                             LowerSmallDrawerFrontViewModel(input: input, boardName: "Kis fiókelő", savedBoards: boards),
                             LowerDrawerFrontViewModel(input: input, boardName: "Nagy fiókelő", savedBoards: boards),
                             LowerSmallDrawerSideViewModel(input: input, boardName: "Kis fiók oldal", savedBoards: boards),
                             LowerDrawerSideViewModel(input: input, boardName: "Nagy fiók oldal", savedBoards: boards),
                             LowerSmallDrawerBackViewModel(input: input, boardName: "Kis fiók eleje-hátulja", savedBoards: boards),
                             LowerDrawerBackViewModel(input: input, boardName: "Nagy fiók eleje hátulja", savedBoards: boards),
                             LowerDrawerBottomViewModel(input: input, boardName: "Fiók alja HDF", savedBoards: boards)]
    }
}
