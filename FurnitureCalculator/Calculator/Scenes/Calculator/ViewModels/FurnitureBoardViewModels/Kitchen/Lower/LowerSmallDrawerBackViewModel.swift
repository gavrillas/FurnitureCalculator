//
//  LowerSmallDrawerBackViewModel.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 02. 20..
//  Copyright © 2021. kristof. All rights reserved.
//

import RxSwift
import class RxCocoa.BehaviorRelay

struct LowerSmallDrawerBackViewModel: FurnitureBoardCellViewModel {
    let hasABS = true
    let name: String
    let furnitureBoard: Observable<FurnitureBoard>
    let absType = BehaviorRelay<Int>(value: 0)
    let absWidthQuantity = BehaviorRelay<Int>(value: 0)
    let absHeightQuantity = BehaviorRelay<Int>(value: 0)
    
    init(input: CalculatorInput, boardName: String) {
        name = boardName
        furnitureBoard = Observable
            .combineLatest(input.width,
                           input.smallDrawerHeight,
                           input.smallDrawersQuantity,
                           absType,
                           absWidthQuantity,
                           absHeightQuantity)
            .map { width, height, quantity, absType, absWidthQuantity, absHeightQuantity in
                let boardWidth = width - 9.9
                let smallHeight = height - 5
                return FurnitureBoard(name: boardName,
                                                     typeABS: absType,
                                                     widthABS: absWidthQuantity,
                                                     heightABS: absHeightQuantity,
                                                     width: boardWidth,
                                                     height: smallHeight,
                                                     quantity: quantity * 2,
                                                     isHDF: false,
                                                     isDoor: false)
            }
    }
}
