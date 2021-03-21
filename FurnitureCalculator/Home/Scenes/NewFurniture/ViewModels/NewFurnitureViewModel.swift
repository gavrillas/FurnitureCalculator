//
//  NewFurnitureViewModel.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 16..
//  Copyright © 2021. kristof. All rights reserved.
//


struct NewFurnitureViewModel {
    private let _measurement: Measurement
    private let _useCase: FurnitureUseCase
    
    init(measurement: Measurement, useCase: FurnitureUseCase) {
        _measurement = measurement
        _useCase = useCase
    }
    
    public func saveFurniture(name: String, type: FurnitureType) -> Furniture{
        let furniture = Furniture()
        furniture.Name = name
        furniture.TypeOfFurniture = type.rawValue
        _useCase.saveFurniture(measurement: _measurement, furniture: furniture, type: type)
        return furniture
    }
}
