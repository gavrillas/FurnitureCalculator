//
//  UpperViewModel.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 02. 15..
//  Copyright © 2021. kristof. All rights reserved.
//

import RxSwift

struct UpperViewModel: CalculatorViewModel {
    let furniture: Furniture
    let useCase: ComponentUseCase
    let resultViewModels: [FurnitureBoardCellViewModel]
    let parameterViewModels: [ParameterCellViewModel]
    let input: CalculatorInput
    let storedComponent: BehaviorSubject<Component?>
    let componentType: Component.ComponentType = .Upper
    
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
                                                      keyboard: .numberPad)]
        
        
        
        var savedBoards: [FurnitureBoard]? = nil
        if let boards = component?.FurnitureBoards {
            savedBoards = Array(boards)
        }
        
        resultViewModels = [EntireTopBottomViewModel(input: input, boardName: "Tető", savedBoards: savedBoards),
                             UpperBottomViewModel(input: input, boardName: "Fenék", savedBoards: savedBoards),
                             UpperSideViewModel(input: input, boardName: "Oldal", savedBoards: savedBoards),
                             ShelfViewModel(input: input, boardName: "Polc", savedBoards: savedBoards),
                             UpperDoorViewModel(input: input, boardName: "Ajtó", savedBoards: savedBoards),
                             HDFViewModel(input: input, boardName: "HDF", savedBoards: savedBoards),]
    }
}
