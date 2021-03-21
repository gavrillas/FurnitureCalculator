//
//  RealmHelper.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 06..
//  Copyright © 2021. kristof. All rights reserved.
//

import RealmSwift

public class RealmHelper {
    public static let k_SchemaVersion: UInt64 = 3
    
    public static var realm: Realm {
        do {
            let realm = try Realm()
            return realm
        } catch {
            fatalError("# Realm init failed.")
        }
    }
}

extension Realm {
    func deleteRecursively(_ object: Object) {
        let schema = object.objectSchema
        schema.properties.forEach { property in
            switch property.type {
            case .object:
                if let obj = object.value(forKey: property.name) as? Object {
                    deleteRecursively(obj)
                } else if let obj = object.value(forKey: property.name) as? ListBase {
                    let list = ObjectiveCSupport.convert(object: obj._rlmArray)
                    list.forEach { deleteRecursively($0) }
                }
            default:
                break
            }
        }
        delete(object)
    }
    
    func deleteRecursively<T: Object>(_ objects: Results<T>) {
        objects.forEach { deleteRecursively($0) }
    }
}
