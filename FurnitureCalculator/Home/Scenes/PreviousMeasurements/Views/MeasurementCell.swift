//
//  MeasurementTableViewCell.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 06..
//  Copyright © 2021. kristof. All rights reserved.
//

import UIKit

class MeasurementCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    public func config(measurement: Measurement) {
        titleLabel.text = measurement.Name
    }

}
