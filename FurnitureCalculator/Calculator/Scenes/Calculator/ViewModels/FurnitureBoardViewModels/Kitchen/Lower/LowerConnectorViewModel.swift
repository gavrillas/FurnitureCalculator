//
//  LowerConnectorViewModel.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 02. 20..
//  Copyright © 2021. kristof. All rights reserved.
//

import RxSwift
import class RxCocoa.BehaviorRelay

struct LowerConnectorViewModel: FurnitureBoardCellViewModel {
    let hasABS = true
    let name: String
    let furnitureBoard: Observable<FurnitureBoard>
    let absType = BehaviorRelay<Int>(value: 0)
    let absWidthQuantity = BehaviorRelay<Int>(value: 0)
    let absHeightQuantity = BehaviorRelay<Int>(value: 0)
    
    init(input: CalculatorInput, boardName: String) {
        name = boardName
        furnitureBoard = Observable
            .combineLatest(input.width, absType, absWidthQuantity, absHeightQuantity)
            .map { width, absType, absWidthQuantity, absHeightQuantity in
                FurnitureBoard(name: boardName,
                               typeABS: absType,
                               widthABS: absWidthQuantity,
                               heightABS: absHeightQuantity,
                               width: width - 2 * boardThickness,
                               height: 10,
                               quantity: 2,
                               isHDF: false,
                               isDoor: false)
            }
    }
}
