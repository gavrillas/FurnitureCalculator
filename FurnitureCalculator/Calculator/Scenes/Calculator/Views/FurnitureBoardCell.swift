//
//  FurnitureBoardCell.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 02. 12..
//  Copyright © 2021. kristof. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FurnitureBoardCell: UITableViewCell {
    @IBOutlet weak var boardName: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var absType: UISegmentedControl!
    @IBOutlet weak var absWidthQuantity: UISegmentedControl!
    @IBOutlet weak var absHeightQuantity: UISegmentedControl!
    @IBOutlet weak var absStackView: UIStackView!
    
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
    
    public func config(with viewModel: FurnitureBoardCellViewModel) {
        self.absStackView.isHidden = !viewModel.hasABS
        viewModel.furnitureBoard.subscribe(onNext: { [unowned self] furnitureBoard in
            self.boardName.text = furnitureBoard.BoardName
            self.sizeLabel.text = furnitureBoard.text
        }).disposed(by: _disposeBag)
        
        (absType.rx.selectedSegmentIndex
            <-> viewModel.absType)
            .disposed(by: _disposeBag)
        
        (absWidthQuantity.rx.selectedSegmentIndex
            <-> viewModel.absWidthQuantity)
            .disposed(by: _disposeBag)
        
        (absHeightQuantity.rx.selectedSegmentIndex
            <-> viewModel.absHeightQuantity)
            .disposed(by: _disposeBag)
    }
}
