//
//  SaveComponentCell.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 02. 13..
//  Copyright © 2021. kristof. All rights reserved.
//

import UIKit
import RxSwift

class SaveComponentCell: UITableViewCell {
    @IBOutlet weak var saveButton: RoundedButton!

    private var _disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        _disposeBag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(with viewModel: SaveComponentCellViewModel) {
        saveButton.rx.tap
            .bind(to: viewModel.save)
            .disposed(by: _disposeBag)
    }

}

struct SaveComponentCellViewModel {
    let save: PublishSubject<Void>
    
    init(save: PublishSubject<Void>) {
        self.save = save
    }
}
