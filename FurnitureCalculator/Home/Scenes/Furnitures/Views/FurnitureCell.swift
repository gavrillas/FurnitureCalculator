//
//  FurnitureCell.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 08..
//  Copyright © 2021. kristof. All rights reserved.
//

import UIKit

class FurnitureCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    public func config(furniture: Furniture) {
        titleLabel.text = furniture.Name
    }
}
