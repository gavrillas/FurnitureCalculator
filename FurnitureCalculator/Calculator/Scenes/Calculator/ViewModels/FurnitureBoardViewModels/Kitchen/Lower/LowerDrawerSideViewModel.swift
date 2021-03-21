//
//  LowerDrawerSideViewModel.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 02. 20..
//  Copyright © 2021. kristof. All rights reserved.
//

import RxSwift
import class RxCocoa.BehaviorRelay

struct LowerDrawerSideViewModel: FurnitureBoardCellViewModel {
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
            .combineLatest(input.depth,
                           frontBoard,
                           input.drawersQuantity,
                           absType,
                           absWidthQuantity,
                           absHeightQuantity)
            .map { depth, drawerFrontBoard, quantity, absType, absWidthQuantity, absHeightQuantity in
                let drawerFrontHeight = drawerFrontBoard.Height
                let boardWidth = depth - 5
                let smallHeight = drawerFrontHeight - 5
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

