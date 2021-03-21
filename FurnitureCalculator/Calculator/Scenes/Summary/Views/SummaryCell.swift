//
//  SummaryCell.swift
//  FurnitureCalculator
//
//  Created by kristof on 2021. 01. 19..
//  Copyright © 2021. kristof. All rights reserved.
//

import UIKit
import RxSwift

class SummaryCell: UITableViewCell {
    @IBOutlet weak var materialPriceField: UITextField!
    @IBOutlet weak var hdfPriceField: UITextField!
    @IBOutlet weak var doorPriceField: UITextField!
    @IBOutlet weak var abs2PriceField: UITextField!
    @IBOutlet weak var abs04PriceField: UITextField!
    
    @IBOutlet weak var boardAmountLabel: UILabel!
    @IBOutlet weak var hdfAmountLabel: UILabel!
    @IBOutlet weak var doorAmountLabel: UILabel!
    @IBOutlet weak var abs2AmountLabel: UILabel!
    @IBOutlet weak var abs04AmountLabel: UILabel!
    @IBOutlet weak var boardPriceLabel: UILabel!
    @IBOutlet weak var hdfPriceLabel: UILabel!
    @IBOutlet weak var doorPriceLabel: UILabel!
    @IBOutlet weak var abs2PriceLabel: UILabel!
    @IBOutlet weak var abs04PriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    private var _disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        _disposeBag = DisposeBag()
    }
    
    public func config(with viewModel: SummaryCellViewModel) {
        boardAmountLabel.text = String(format: "%.1f", viewModel.simpleBoardsAmount) + " m²"
        hdfAmountLabel.text = String(format: "%.1f", viewModel.hdfBoardsAmount) + " m²"
        doorAmountLabel.text = String(format: "%.1f", viewModel.doorBoardsAmount) + " m²"
        abs2AmountLabel.text = String(format: "%.1f", viewModel.ABS2Amount) + "m"
        
        abs04AmountLabel.text = String(format: "%.1f", viewModel.ABS04Amount) + "m"
        
        let materialPrice = materialPriceField.rx
            .text.orEmpty
            .compactMap { Int($0) }
            .asObservable()
        
        let hdfPrice = hdfPriceField.rx
            .text.orEmpty
            .compactMap { Int($0) }
            .asObservable()
        
        let doorPrice = doorPriceField.rx
            .text.orEmpty
            .compactMap { Int($0) }
            .asObservable()
        
        let abs2Price = abs2PriceField.rx
            .text.orEmpty
            .compactMap { Int($0) }
            .asObservable()
        
        let abs04Price = abs04PriceField.rx
            .text.orEmpty
            .compactMap { Int($0) }
            .asObservable()
        
        let input = SummaryCellViewModel.Input(materialValue: materialPrice,
                                               hdfValue: hdfPrice,
                                               doorValue: doorPrice,
                                               abs2Value: abs2Price,
                                               abs04Value: abs04Price)
        
        let output = viewModel.transform(input: input)
        
        output.materialPrice.drive(onNext: { [unowned self] price in
            boardPriceLabel.text = String(format: "%.0f", price) + " Ft"
        }).disposed(by: _disposeBag)
        
        output.hdfPrice.drive(onNext: { [unowned self] price in
            hdfPriceLabel.text = String(format: "%.0f", price) + " Ft"
        }).disposed(by: _disposeBag)
        
        output.doorPrice.drive(onNext: { [unowned self] price in
            doorPriceLabel.text = String(format: "%.0f", price) + " Ft"
        }).disposed(by: _disposeBag)
        
        output.abs2Price.drive(onNext: { [unowned self] price in
            abs2PriceLabel.text = String(format: "%.0f", price) + " Ft"
        }).disposed(by: _disposeBag)
        
        output.abs04Price.drive(onNext: { [unowned self] price in
            abs04PriceLabel.text = String(format: "%.0f", price) + " Ft"
        }).disposed(by: _disposeBag)
        
        output.totalPrice.drive(onNext: { [unowned self] price in
            totalPriceLabel.text = String(format: "%.0f", price) + " Ft"
        }).disposed(by: _disposeBag)
        
        materialPriceField.text = String(viewModel.boardValue)
        hdfPriceField.text = String(viewModel.hdfValue)
        doorPriceField.text = String(viewModel.doorValue)
        abs2PriceField.text = String(viewModel.abs2Value)
        abs04PriceField.text = String(viewModel.abs04Value)
        
        materialPriceField.sendActions(for: .valueChanged)
        hdfPriceField.sendActions(for: .valueChanged)
        doorPriceField.sendActions(for: .valueChanged)
        abs2PriceField.sendActions(for: .valueChanged)
        abs04PriceField.sendActions(for: .valueChanged)
    }
}
