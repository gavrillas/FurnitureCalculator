//
//  LowerSmallDrawerSideViewModel.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 02. 20..
//  Copyright © 2021. kristof. All rights reserved.
//

import RxSwift
import class RxCocoa.BehaviorRelay

struct LowerSmallDrawerSideViewModel: FurnitureBoardCellViewModel {
    let hasABS = true
    let name: String
    let furnitureBoard: Observable<FurnitureBoard>
    let absType = BehaviorRelay<Int>(value: 0)
    let absWidthQuantity = BehaviorRelay<Int>(value: 0)
    let absHeightQuantity = BehaviorRelay<Int>(value: 0)
    
    init(input: CalculatorInput, boardName: String) {
        name = boardName
        furnitureBoard = Observable
            .combineLatest(input.depth,
                           input.smallDrawerHeight,
                           input.smallDrawersQuantity,
                           absType,
                           absWidthQuantity,
                           absHeightQuantity)
            .map { depth, drawerFrontHeight, quantity, absType, absWidthQuantity, absHeightQuantity in
                let boardWith = depth - 5
                let smallHeight = drawerFrontHeight - 5
                return FurnitureBoard(name: boardName,
                                                     typeABS: absType,
                                                     widthABS: absWidthQuantity,
                                                     heightABS: absHeightQuantity,
                                                     width: boardWith,
                                                     height: smallHeight,
                                                     quantity: quantity * 2,
                                                     isHDF: false,
                                                     isDoor: false)
            }
    }
}
