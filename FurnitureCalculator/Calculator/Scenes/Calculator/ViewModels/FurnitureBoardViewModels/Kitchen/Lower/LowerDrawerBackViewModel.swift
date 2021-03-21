//
//  LowerDrawerBackViewModel.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 02. 20..
//  Copyright © 2021. kristof. All rights reserved.
//

import RxSwift
import class RxCocoa.BehaviorRelay

struct LowerDrawerBackViewModel: FurnitureBoardCellViewModel {
    let hasABS = true
    let name: String
    let furnitureBoard: Observable<FurnitureBoard>
    let absType = BehaviorRelay<Int>(value: 0)
    let absWidthQuantity = BehaviorRelay<Int>(value: 0)
    let absHeightQuantity = BehaviorRelay<Int>(value: 0)
    
    init(input: CalculatorInput, boardName: String) {
        name = boardName
        let frontBoard = LowerDrawerFrontViewModel(input: input, boardName: "").furnitureBoard
        furnitureBoard = Observable
            .combineLatest(input.width,
                           frontBoard,
                           input.drawersQuantity,
                           absType,
                           absWidthQuantity,
                           absHeightQuantity)
            .map { width, drawerFrontBoard, quantity, absType, absWidthQuantity, absHeightQuantity in
                let drawerFrontHeight = drawerFrontBoard.Height
                let boardWidth = width - 9.9
                let height = drawerFrontHeight - 5
                return FurnitureBoard(name: boardName,
                                      typeABS: absType,
                                      widthABS: absWidthQuantity,
                                      heightABS: absHeightQuantity,
                                      width: boardWidth,
                                      height: height,
                                      quantity: quantity * 2,
                                      isHDF: false,
                                      isDoor: false)
            }
    }
}
