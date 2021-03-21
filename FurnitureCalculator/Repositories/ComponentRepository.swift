//
//  ComponentRepository.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 18..
//  Copyright © 2021. kristof. All rights reserved.
//

import RealmSwift

protocol ComponentUseCase {
    func saveComponent(furniture: Furniture, component: Component)
    func deleteComponent(component: Component)
    func updateComponent(savedComponent: Component, newComponent: Component)
}

extension ComponentUseCase {
    static func make() -> ComponentRepository {
        ComponentRepository()
    }
}

struct ComponentRepository: ComponentUseCase {
    private let _realm = RealmHelper.realm
    
    func saveComponent(furniture: Furniture, component: Component) {
        do {
            try _realm.write {
                furniture.Components.append(component)
            }
        } catch {
            return
        }
    }
    
    func deleteComponent(component: Component) {
        do {
            try _realm.write {
                _realm.deleteRecursively(component)
            }
        } catch {
            return
        }
    }
    
    func updateComponent(savedComponent: Component, newComponent: Component) {
        do {
            try _realm.write {
                savedComponent.Name = newComponent.Name
                savedComponent.Width = newComponent.Width
                savedComponent.Height = newComponent.Height
                savedComponent.Depth = newComponent.Depth
                savedComponent.Shelf = newComponent.Shelf
                savedComponent.Door = newComponent.Door
                savedComponent.DrawersQuantity = newComponent.DrawersQuantity
                savedComponent.SmallDrawersHeight = newComponent.SmallDrawersHeight
                savedComponent.PartitionWalls = newComponent.PartitionWalls
                savedComponent.SmallDrawersQuantity = newComponent.SmallDrawersQuantity
                savedComponent.DrawersHeight = newComponent.DrawersHeight
                for (board1, board2) in zip(savedComponent.FurnitureBoards, newComponent.FurnitureBoards) {
                    board1.BoardName = board2.BoardName
                    board1.HeightABS = board2.HeightABS
                    board1.WidthABS = board2.WidthABS
                    board1.ABS = board2.ABS
                    board1.Height = board2.Height
                    board1.Width = board2.Width
                    board1.Quantity = board2.Quantity
                    board1.IsHDF = board2.IsHDF
                    board1.IsDoor = board2.IsDoor
                }
            }
        } catch {
            return
        }
    }
    
}
