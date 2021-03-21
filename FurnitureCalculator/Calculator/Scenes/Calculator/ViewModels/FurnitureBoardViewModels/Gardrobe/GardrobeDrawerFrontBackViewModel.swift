//
//  GardrobeDrawerFrontBack.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 02. 20..
//  Copyright © 2021. kristof. All rights reserved.
//

import RxSwift
import class RxCocoa.BehaviorRelay

struct GardrobeDrawerFrontBackViewModel: FurnitureBoardCellViewModel {
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
                           input.drawerHeight,
                           input.drawersQuantity,
                           input.partitionWall,
                           absType,
                           absWidthQuantity,
                           absHeightQuantity)
            .map { width, height ,quantity, partionWalls, absType, absWidthQuantity, absHeightQuantity in
                var drawerWidth = (width - (2.0 + Double(partionWalls)) * boardThickness)
                if partionWalls > 0 {
                    drawerWidth = drawerWidth / Double(partionWalls + 1)
                }
                drawerWidth = drawerWidth - boardThickness
                return FurnitureBoard(name: boardName,
                                      typeABS: absType,
                                      widthABS: absWidthQuantity,
                                      heightABS: absHeightQuantity,
                                      width: drawerWidth,
                                      height: height,
                                      quantity: quantity,
                                      isHDF: false,
                                      isDoor: false)
            }
    }
}
