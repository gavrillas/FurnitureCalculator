//
//  SummaryCellViewModel.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 20..
//  Copyright © 2021. kristof. All rights reserved.
//

import RxSwift
import struct RxCocoa.Driver

struct SummaryCellViewModel: ViewModelType {
    struct Input {
        let materialValue: Observable<Int>
        let hdfValue: Observable<Int>
        let doorValue: Observable<Int>
        let abs2Value: Observable<Int>
        let abs04Value: Observable<Int>
    }
    
    struct Output {
        let materialPrice: Driver<Double>
        let hdfPrice: Driver<Double>
        let doorPrice: Driver<Double>
        let abs2Price: Driver<Double>
        let abs04Price: Driver<Double>
        let totalPrice: Driver<Double>
    }
    
    private let _furniture: Furniture!
    private let _useCase: FurnitureRepository!
    
    private var _boards: [FurnitureBoard] {
        _furniture.Components
            .flatMap({ $0.FurnitureBoards })
    }
    
    public var hdfBoardsAmount: Double {
        _boards.filter{ $0.IsHDF }
            .map{ $0.squareMeter }
            .reduce(0, { $0 + $1 })
    }
    
    public var simpleBoardsAmount: Double {
        _boards.filter{ !$0.IsHDF && !$0.IsDoor }
            .map{ $0.squareMeter}
            .reduce(0, { $0 + $1 })
    }
    
    public var doorBoardsAmount: Double {
        _boards.filter{ $0.IsDoor }
            .map{ $0.squareMeter }
            .reduce(0, { $0 + $1 })
    }
    
    public var ABS2Amount: Double {
        _boards.filter{ $0.ABS == 0}
            .map{ $0.lengthOfABS }
            .reduce(0, { $0 + $1 })
    }
    
    public var ABS04Amount: Double {
        _boards.filter{ $0.ABS == 1}
            .map{ $0.lengthOfABS }
            .reduce(0, { $0 + $1 })
    }
    
    public var boardValue: Int { _furniture.BoardPrice }
    public var hdfValue: Int { _furniture.HDFPrice }
    public var doorValue: Int { _furniture.DoorPrice}
    public var abs2Value: Int { _furniture.ABS2Price }
    public var abs04Value: Int { _furniture.ABS04Price }
    
    init(furniture: Furniture, useCase: FurnitureRepository) {
        _furniture = furniture
        _useCase = useCase
    }
    
    public func transform(input: Input) -> Output{
        let materialPrice = input.materialValue.distinctUntilChanged()
            .map { price in
                _useCase.updateFurnitre(furniture: _furniture, boardPrice: price)
                _boards.filter{ !$0.IsHDF && !$0.IsDoor }.forEach { print($0.squareMeter) }
            return simpleBoardsAmount * Double(price)
        }.asDriver(onErrorJustReturn: 0.0)
        
        let hdfPrice = input.hdfValue.distinctUntilChanged()
            .map { price in
                _useCase.updateFurnitre(furniture: _furniture, hdfPrice: price)
            return hdfBoardsAmount * Double(price)
        }.asDriver(onErrorJustReturn: 0.0)
        
        let doorPrice = input.doorValue.distinctUntilChanged()
            .map { price in
                _useCase.updateFurnitre(furniture: _furniture, doorPrice: price)
            return doorBoardsAmount * Double(price)
        }.asDriver(onErrorJustReturn: 0.0)
        
        let abs2Price = input.abs2Value.distinctUntilChanged()
            .map { price in
                _useCase.updateFurnitre(furniture: _furniture, abs2Price: price)
                return ABS2Amount * Double(price)
            }.asDriver(onErrorJustReturn: 0.0)
        
        let abs04Price = input.abs04Value.distinctUntilChanged()
            .map { price in
                _useCase.updateFurnitre(furniture: _furniture, abs04Price: price)
                return ABS04Amount * Double(price)
            }.asDriver(onErrorJustReturn: 0.0)
        
        let totalPrice = Driver
            .combineLatest(materialPrice, hdfPrice, doorPrice, abs2Price, abs04Price)
            .map { $0 + $1 + $2 + $3 + $4}
        
        return Output(materialPrice: materialPrice,
               hdfPrice: hdfPrice,
               doorPrice: doorPrice,
               abs2Price: abs2Price,
               abs04Price: abs04Price,
               totalPrice: totalPrice)
    }
}
