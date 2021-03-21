//
//  GardrobeShelfViewModel.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 02. 20..
//  Copyright © 2021. kristof. All rights reserved.
//

import RxSwift
import class RxCocoa.BehaviorRelay

struct GardrobeShelfViewModel: FurnitureBoardCellViewModel {
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
                           input.width,
                           input.partitionWall,
                           input.shelf,
                           absType,
                           absWidthQuantity,
                           absHeightQuantity)
            .map { depth, width, partionWalls, quantity, absType, absWidthQuantity, absHeightQuantity in
                let shelfWidth = Double(width - Double(2 + partionWalls) * boardThickness) / Double(partionWalls + 1)
                let shelfDepth = depth - 10
                return FurnitureBoard(name: boardName,
                                      typeABS: absType,
                                      widthABS: absWidthQuantity,
                                      heightABS: absHeightQuantity,
                                      width: shelfWidth,
                                      height: shelfDepth,
                                      quantity: quantity,
                                      isHDF: false,
                                      isDoor: false)
            }
    }
}
