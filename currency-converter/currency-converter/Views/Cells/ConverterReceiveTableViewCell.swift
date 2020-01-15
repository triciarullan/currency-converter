//
//  ConverterReceiveTableViewCell.swift
//  currency-converter
//
//  Created by Tric Rullan on 1/8/20.
//  Copyright © 2020 Tric. All rights reserved.
//

import UIKit

class ConverterReceiveTableViewCell: UITableViewCell {

   @IBOutlet private weak var amountLabel: UILabel!
   @IBOutlet private weak var currencyLabel: UILabel!
   
   var viewModel: ConverterReceiveTableCellViewModel! {
      didSet {
         bindViewModel()
      }
   }
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }

   // MARK: - Privates
   
   private func bindViewModel() {
      amountLabel.text = viewModel.amountText
      currencyLabel.text = viewModel.currency
   }
   
   // MARK: - IBActions
   
   @IBAction private func didTapChangeCurrency(_ sender: Any) {
      viewModel.onTapUpdateCurrencyReceive?()
   }
   
}

// MARK: - CurrencyItemModelBindableType

extension ConverterReceiveTableViewCell: CurrencyItemModelBindableType {
   func setItemModel(_ itemModel: CurrencyItemModel) {
      guard let viewModel: ConverterReceiveTableCellViewModel = itemModel.viewModel() else {
         fatalError("View model mismatched!")
      }
      self.viewModel = viewModel
   }
}
