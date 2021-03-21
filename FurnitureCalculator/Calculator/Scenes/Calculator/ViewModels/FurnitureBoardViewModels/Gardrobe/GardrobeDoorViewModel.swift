//
//  GardrobeDoorViewModel.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 02. 20..
//  Copyright © 2021. kristof. All rights reserved.
//

import RxSwift
import class RxCocoa.BehaviorRelay

struct GardrobeDoorViewModel: FurnitureBoardCellViewModel {
    let hasABS = true
    let name: String
    let furnitureBoard: Observable<FurnitureBoard>
    let absType = BehaviorRelay<Int>(value: 0)
    let absWidthQuantity = BehaviorRelay<Int>(value: 0)
    let absHeightQuantity = BehaviorRelay<Int>(value: 0)
    
    init(input: CalculatorInput, boardName: String) {
        name = boardName
        furnitureBoard = Observable
            .combineLatest(input.height,
                           input.width,
                           input.door,
                           absType,
                           absWidthQuantity,
                           absHeightQuantity)
            .map { height, width, quantity, absType, absWidthQuantity, absHeightQuantity in
                let doorHeight = height - 2 * boardThickness - 3
                let doorWidth = Double(width - 2 * boardThickness) / Double(quantity) - 2.0
                return FurnitureBoard(name: boardName,
                                      typeABS: absType,
                                      widthABS: absWidthQuantity,
                                      heightABS: absHeightQuantity,
                                      width: doorWidth,
                                      height: doorHeight,
                                      quantity: quantity,
                                      isHDF: false,
                                      isDoor: false)
            }
    }
}
