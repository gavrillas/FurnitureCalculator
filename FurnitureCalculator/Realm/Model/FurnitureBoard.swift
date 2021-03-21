//
//  FurnitureBoard.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 22..
//  Copyright © 2021. kristof. All rights reserved.
//

import Foundation
import RealmSwift

public enum TypeABS: Int {
    case big = 0
    case small = 1
}

public class FurnitureBoard: Object {
    @objc public dynamic var BoardName = ""
    @objc public dynamic var WidthABS = 0
    @objc public dynamic var HeightABS = 0
    @objc public dynamic var ABS = 0
    @objc public dynamic var Width = 0.0
    @objc public dynamic var Height = 0.0
    @objc public dynamic var Quantity = 0
    @objc public dynamic var IsHDF = false
    @objc public dynamic var IsDoor = false
    
    var text: String {
        guard Quantity > 0 else { return "Nincs" }
        return "\(String(format: "%.1f", Width)) X \(String(format: "%.1f", Height)) - \(Quantity) db"
    }
    
    var squareMeter: Double {
        guard Quantity > 0 else { return 0 }
        return Width * Height * Double(Quantity) / 10000.0
    }
    
    var absType: TypeABS {
        TypeABS(rawValue: ABS) ?? .big
    }
    
    var lengthOfABS: Double {
        return ((Height * Double(HeightABS) + Width * Double(WidthABS)) * Double(Quantity)) / 100.0
    }
    
    public convenience init(name: String = "",
                            typeABS: Int = 0,
                            widthABS: Int = 0,
                            heightABS: Int = 0,
                            width: Double,
                            height: Double,
                            quantity: Int,
                            isHDF: Bool = false,
                            isDoor: Bool = false) {
        self.init()
        BoardName = name
        ABS = typeABS
        WidthABS = widthABS
        HeightABS = heightABS
        Width = width
        Height = height
        Quantity = quantity
        IsHDF = isHDF
        IsDoor = isDoor
    }
}
