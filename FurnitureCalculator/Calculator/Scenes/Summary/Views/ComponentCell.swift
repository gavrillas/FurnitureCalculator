//
//  ComponentCell.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 19..
//  Copyright © 2021. kristof. All rights reserved.
//

import UIKit

class ComponentCell: UITableViewCell {
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func config(component: Component) {
        type.text = component.componentType.rawValue
        name.text = component.Name
    }

}
