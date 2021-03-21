//
//  ParameterCell.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 02. 10..
//  Copyright © 2021. kristof. All rights reserved.
//

import UIKit
import RxSwift
import class RxCocoa.BehaviorRelay

class ParameterCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var value: UITextField!
    
    private var _disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        _disposeBag = DisposeBag()
    }
    
    public func config(with vm: ParameterCellViewModel) {
        name.text = vm.name
        value.keyboardType = vm.keyboard
        (value.rx.text
            .orEmpty
             <-> vm.value)
            .disposed(by: _disposeBag)
    }
}

struct ParameterCellViewModel {
    let name: String
    let value: BehaviorRelay<String>
    let keyboard: UIKeyboardType
    
    init(name: String, value: BehaviorRelay<String>, keyboard: UIKeyboardType) {
        self.name = name
        self.value = value
        self.keyboard = keyboard
    }
}
