//
//  Measurement.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 06..
//  Copyright © 2021. kristof. All rights reserved.
//

import Foundation
import RealmSwift

public class Measurement: Object {
    @objc public dynamic var Name = ""
    public let Kitchen = List<Furniture>()
    public let Gardrobe = List<Furniture>()
    public let Others = List<Furniture>()
    
    public override static func primaryKey() -> String? {
        return "Name"
    }
}
