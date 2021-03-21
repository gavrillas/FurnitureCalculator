//
//  MeasurementRepository.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 06..
//  Copyright © 2021. kristof. All rights reserved.
//

import RealmSwift

protocol MeasurementUseCase {
    var measurements: [Measurement] { get }
    func saveMeasurement(measurement: Measurement)
    func deleteMeasurement(measurement: Measurement)
}

extension MeasurementUseCase {
    static func make() -> MeasurementUseCase {
        MeasurementRepository()
    }
}


struct MeasurementRepository: MeasurementUseCase {
    private let _realm = RealmHelper.realm
    
    var measurements: [Measurement] {
        Array(_realm.objects(Measurement.self))
    }
    
    func saveMeasurement(measurement: Measurement) {
        do {
            try _realm.write {
                _realm.add(measurement)
            }
        } catch {
            return
        }
    }
    
    func deleteMeasurement(measurement: Measurement) {
        do {
            try _realm.write {
                _realm.deleteRecursively(measurement)
            }
        } catch {
            return
        }
    }
}
