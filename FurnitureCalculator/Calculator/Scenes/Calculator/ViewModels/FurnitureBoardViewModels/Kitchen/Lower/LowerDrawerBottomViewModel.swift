//
//  LowerDrawerBottomViewModel.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 02. 20..
//  Copyright © 2021. kristof. All rights reserved.
//

import RxSwift
import class RxCocoa.BehaviorRelay

struct LowerDrawerBottomViewModel: FurnitureBoardCellViewModel {
    let hasABS = false
    let name: String
    let furnitureBoard: Observable<FurnitureBoard>
    let absType = BehaviorRelay<Int>(value: 0)
    let absWidthQuantity = BehaviorRelay<Int>(value: 0)
    let absHeightQuantity = BehaviorRelay<Int>(value: 0)
    
    init(input: CalculatorInput, boardName: String) {
        name = boardName
        furnitureBoard = Observable
            .combineLatest(input.depth,
                           input.width,
                           input.drawersQuantity,
                           input.smallDrawersQuantity,
                           absType,
                           absWidthQuantity,
                           absHeightQuantity)
            .map { depth, width, quantity, smallQuantity, absType, absWidthQuantity, absHeightQuantity in
                return FurnitureBoard(name: boardName,
                                      typeABS: absType,
                                      widthABS: absWidthQuantity,
                                      heightABS: absHeightQuantity,
                                      width: width - 6.6,
                                      height: depth - 5.3,
                                      quantity: quantity + smallQuantity,
                                      isHDF: true,
                                      isDoor: false)
            }
    }
}
