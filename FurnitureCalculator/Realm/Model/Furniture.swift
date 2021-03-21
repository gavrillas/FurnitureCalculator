//
//  Furniture.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 06..
//  Copyright © 2021. kristof. All rights reserved.
//

import Foundation
import RealmSwift

public enum FurnitureType: Int {
    case Kitchen
    case Gardrobe
    case Other
}

public class Furniture: Object {
    
    @objc public dynamic var Name = ""
    @objc public dynamic var TypeOfFurniture = 0
    @objc public dynamic var BoardPrice = 0
    @objc public dynamic var HDFPrice = 0
    @objc public dynamic var DoorPrice = 0
    @objc public dynamic var ABS2Price = 0
    @objc public dynamic var ABS04Price = 0
    public let Components = List<Component>()
    
    public var type: FurnitureType {
        FurnitureType(rawValue: TypeOfFurniture) ?? .Kitchen
    }
}
