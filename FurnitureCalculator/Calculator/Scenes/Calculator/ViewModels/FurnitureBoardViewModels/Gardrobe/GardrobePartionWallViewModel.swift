//
//  GardrobePartionWallViewModel.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 02. 20..
//  Copyright © 2021. kristof. All rights reserved.
//

import RxSwift

import RxSwift
import class RxCocoa.BehaviorRelay

struct GardrobePartionWallViewModel: FurnitureBoardCellViewModel {
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
                           input.height,
                           input.partitionWall,
                           absType,
                           absWidthQuantity,
                           absHeightQuantity)
            .map { depth, height, quantity, absType, absWidthQuantity, absHeightQuantity in
                let sideHeight = height - 2.0 * boardThickness
                let sideDepth = depth - 10.0
                return FurnitureBoard(name: boardName,
                                      typeABS: absType,
                                      widthABS: absWidthQuantity,
                                      heightABS: absHeightQuantity,
                                      width: sideDepth,
                                      height: sideHeight,
                                      quantity: quantity,
                                      isHDF: false,
                                      isDoor: false)
            }
    }
}
