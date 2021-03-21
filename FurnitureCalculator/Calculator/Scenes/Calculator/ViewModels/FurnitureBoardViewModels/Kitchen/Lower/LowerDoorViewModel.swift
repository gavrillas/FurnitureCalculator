//
//  LowerDoorViewModel.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 02. 20..
//  Copyright © 2021. kristof. All rights reserved.
//

import RxSwift
import class RxCocoa.BehaviorRelay

struct LowerDoorViewModel: FurnitureBoardCellViewModel {
    let hasABS = true
    let name: String
    let furnitureBoard: Observable<FurnitureBoard>
    let absType = BehaviorRelay<Int>(value: 0)
    let absWidthQuantity = BehaviorRelay<Int>(value: 0)
    let absHeightQuantity = BehaviorRelay<Int>(value: 0)
    
    init(input: CalculatorInput, boardName: String) {
        name = boardName
        furnitureBoard = Observable
            .combineLatest(input.width, input.height, input.door, absType, absWidthQuantity, absHeightQuantity)
            .map { width, height, quantity, absType, absWidthQuantity, absHeightQuantity in
                if quantity == 0 {
                    return FurnitureBoard(name: boardName,
                                          typeABS: absType,
                                          widthABS: absWidthQuantity,
                                          heightABS: absHeightQuantity,
                                          width: 0,
                                          height: 0,
                                          quantity: 0,
                                          isDoor: true)
                }
                
                let doorWidth = width / Double(quantity) - 2.0 * absThickness - 2.0 * doorSpace
                let doorHeight = height - legHeight - 2.0 * absThickness - 2.0 * doorSpace - workDeskThickness
                return FurnitureBoard(name: boardName,
                                      typeABS: absType,
                                      widthABS: absWidthQuantity,
                                      heightABS: absHeightQuantity,
                                      width: doorWidth,
                                      height: doorHeight,
                                      quantity: quantity,
                                      isDoor: true)
            }
    }
}
