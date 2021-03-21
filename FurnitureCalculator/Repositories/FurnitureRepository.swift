//
//  FurnitureRepository.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 18..
//  Copyright © 2021. kristof. All rights reserved.
//

import RealmSwift

protocol FurnitureUseCase {
    func saveFurniture(measurement: Measurement, furniture: Furniture, type: FurnitureType)
    func deleteFurniture(furniture: Furniture)
    func updateFurnitre(furniture: Furniture, boardPrice: Int?, hdfPrice: Int?, doorPrice: Int?, abs2Price: Int?, abs04Price: Int?)
}

extension FurnitureUseCase {
    static func make() -> FurnitureRepository {
        FurnitureRepository()
    }
}

struct FurnitureRepository: FurnitureUseCase {
    private let _realm = RealmHelper.realm
    
    func saveFurniture(measurement: Measurement, furniture: Furniture, type: FurnitureType) {
        do {
            try _realm.write {
                switch type {
                case .Kitchen:
                    measurement.Kitchen.append(furniture)
                case .Gardrobe:
                    measurement.Gardrobe.append(furniture)
                case .Other:
                    measurement.Others.append(furniture)
                }
            }
        } catch {
            return
        }
    }
    
    func deleteFurniture(furniture: Furniture) {
        do {
            try _realm.write {
                _realm.deleteRecursively(furniture)
            }
        } catch {
            return
        }
    }
    
    func updateFurnitre(furniture: Furniture,
                        boardPrice: Int? = nil,
                        hdfPrice: Int? = nil,
                        doorPrice: Int? = nil,
                        abs2Price: Int? = nil,
                        abs04Price: Int? = nil) {
        do {
            try _realm.write {
                furniture.BoardPrice = boardPrice ?? furniture.BoardPrice
                furniture.HDFPrice = hdfPrice ?? furniture.HDFPrice
                furniture.DoorPrice = doorPrice ?? furniture.DoorPrice
                furniture.ABS2Price = abs2Price ?? furniture.ABS2Price
                furniture.ABS04Price = abs04Price ?? furniture.ABS04Price
            }
        } catch {
            return
        }
    }
}
