//
//  FurnitureBoardCellViewModel.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 02. 12..
//  Copyright © 2021. kristof. All rights reserved.
//

import RxSwift
import class RxCocoa.BehaviorRelay

let boardThickness =  1.8
let absThickness =  0.2
let doorSpace = 0.15
let legHeight =  10.0
let drawerSpace = 0.3
let workDeskThickness = 3.8

protocol FurnitureBoardCellViewModel {
    var hasABS: Bool { get }
    var name: String { get }
    var absType: BehaviorRelay<Int> { get }
    var absWidthQuantity: BehaviorRelay<Int> { get }
    var absHeightQuantity: BehaviorRelay<Int> { get }
    var furnitureBoard: Observable<FurnitureBoard> { get }
    
    init(input: CalculatorInput, boardName: String)
    init(input: CalculatorInput, boardName: String, savedBoards: [FurnitureBoard]?)
}


extension FurnitureBoardCellViewModel {
    init(input: CalculatorInput, boardName: String, savedBoards: [FurnitureBoard]?) {
        self.init(input: input, boardName: boardName)
        let savedBoard = savedBoards?.first { board in board.BoardName == boardName }
        if let board = savedBoard, hasABS {
            absType.accept(board.absType.rawValue)
            absWidthQuantity.accept(board.WidthABS)
            absHeightQuantity.accept(board.HeightABS)
        }
    }
}
