//
//  LowerDrawerFrontViewModel.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 02. 20..
//  Copyright © 2021. kristof. All rights reserved.
//

import RxSwift
import class RxCocoa.BehaviorRelay

struct LowerDrawerFrontViewModel: FurnitureBoardCellViewModel {
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
                           input.height,
                           input.drawersQuantity,
                           input.smallDrawerHeight,
                           input.smallDrawersQuantity,
                           absType,
                           absWidthQuantity,
                           absHeightQuantity)
            .map { width,
                   height,
                   quantity,
                   smallDrawerHeight,
                   smallDrawersQuantity,
                   absType,
                   absWidthQuantity,
                   absHeightQuantity in
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
                let drawersWidth = width - 2 * absThickness - drawerSpace
                let remainingHeight = height
                    - legHeight
                    - workDeskThickness
                    - Double(smallDrawersQuantity) * Double(smallDrawerHeight)
                
                let drawersHeight = remainingHeight / Double(quantity) - 2 * absThickness - drawerSpace
                
                return FurnitureBoard(name: boardName,
                                      typeABS: absType,
                                      widthABS: absWidthQuantity,
                                      heightABS: absHeightQuantity,
                                      width: drawersWidth,
                                      height: drawersHeight,
                                      quantity: quantity,
                                      isHDF: false,
                                      isDoor: true)
            }
    }
}
