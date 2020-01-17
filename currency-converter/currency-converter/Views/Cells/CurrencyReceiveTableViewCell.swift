//
//  ConverterReceiveTableViewCell.swift
//  currency-converter
//
//  Created by Tric Rullan on 1/8/20.
//  Copyright © 2020 Tric. All rights reserved.
//

import UIKit

class CurrencyReceiveTableViewCell: UITableViewCell {

   @IBOutlet private weak var amountLabel: UILabel!
   @IBOutlet private weak var currencyLabel: UILabel!
   
   var viewModel: CurrencyReceiveTableCellViewModel! {
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

extension CurrencyReceiveTableViewCell: CurrencyItemModelBindableType {
   func setItemModel(_ itemModel: CurrencyItemModel) {
      guard let viewModel: CurrencyReceiveTableCellViewModel = itemModel.viewModel() else {
         fatalError("View model mismatched!")
      }
      self.viewModel = viewModel
   }
}
