//
//  Component.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 06..
//  Copyright © 2021. kristof. All rights reserved.
//

import Foundation
import RealmSwift

public class Component: Object {
    public enum ComponentType: String, Codable {
        case Unkown = ""
        
        case Upper = "Felső"
        case Lower = "Alsó"
        case Tower = "Torony"
        case Gardrobe = "Gardrób"
        case Other = "Egyéb"
    }
    
    @objc public dynamic var Name = ""
    @objc public dynamic var ElementType = ""
    @objc public dynamic var Width = 0.0
    @objc public dynamic var Height = 0.0
    @objc public dynamic var Depth = 0.0
    @objc public dynamic var Shelf = 0
    @objc public dynamic var Door = 0
    @objc public dynamic var PartitionWalls = 0
    @objc public dynamic var DrawersQuantity = 0
    @objc public dynamic var DrawersHeight = 0.0
    @objc public dynamic var SmallDrawersQuantity = 0
    @objc public dynamic var SmallDrawersHeight = 0.0
    
    public var FurnitureBoards = List<FurnitureBoard>()
    
    public var componentType: ComponentType {
        ComponentType(rawValue: ElementType) ?? .Unkown
    }
    
    public convenience init(name: String,
                            width: Double,
                            height: Double,
                            depth: Double,
                            shelf: Int,
                            door: Int,
                            partitionalWalls: Int,
                            drawersQuantity: Int,
                            drawersHeight: Double,
                            smallDrawersQuantity:Int,
                            smallDrawerHeight: Double,
                            type: ComponentType,
                            boards: [FurnitureBoard]) {
        self.init()
        
        Name = name
        Width = width
        Height = height
        Depth = depth
        Shelf = shelf
        Door = door
        PartitionWalls = partitionalWalls
        DrawersQuantity = drawersQuantity
        DrawersHeight = drawersHeight
        SmallDrawersQuantity = smallDrawersQuantity
        SmallDrawersHeight = smallDrawerHeight
        ElementType = type.rawValue
        FurnitureBoards.append(objectsIn: boards)
    }
}
