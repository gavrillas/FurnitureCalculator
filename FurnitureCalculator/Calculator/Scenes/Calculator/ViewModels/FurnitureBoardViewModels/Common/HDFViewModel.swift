//
//  HDFViewModel.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 02. 20..
//  Copyright © 2021. kristof. All rights reserved.
//

import RxSwift
import class RxCocoa.BehaviorRelay

struct HDFViewModel: FurnitureBoardCellViewModel {
    let hasABS = false
    let name: String
    let furnitureBoard: Observable<FurnitureBoard>
    let absType = BehaviorRelay<Int>(value: 0)
    let absWidthQuantity = BehaviorRelay<Int>(value: 0)
    let absHeightQuantity = BehaviorRelay<Int>(value: 0)
    
    init(input: CalculatorInput, boardName: String) {
        name = boardName
        furnitureBoard = Observable
            .combineLatest(input.width, input.height, absType, absWidthQuantity, absHeightQuantity)
            .map { width, height, absType, absWidthQuantity, absHeightQuantity in
                FurnitureBoard(name: boardName,
                               typeABS: absType,
                               widthABS: absWidthQuantity,
                               heightABS: absHeightQuantity,
                               width: width - 0.3,
                               height: height - 0.3,
                               quantity: 1,
                               isHDF: true)
            }
    }
}
