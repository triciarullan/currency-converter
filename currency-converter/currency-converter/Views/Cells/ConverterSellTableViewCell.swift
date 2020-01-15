//
//  ConverterSellCurrencyTableViewCell.swift
//  currency-converter
//
//  Created by Tric Rullan on 1/8/20.
//  Copyright © 2020 Tric. All rights reserved.
//

import UIKit

class ConverterSellTableViewCell: UITableViewCell {

   @IBOutlet private weak var currencyLabel: UILabel!
   @IBOutlet private weak var amountLabel: UITextField!
   
   var viewModel: ConverterSellTableCellViewModel! {
      didSet {
         bindViewModel()
      }
   }
   
   override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
   // MARK: - Privates
   
   private func bindViewModel() {
      amountLabel.text = viewModel.amountText
      currencyLabel.text = viewModel.currency
   }
 
   // MARK: - IBActions
   
   @IBAction private func didTapChangeCurrency(_ sender: Any) {
      viewModel.onTapUpdateCurrencySell?()
   }
   
   @IBAction private func textFieldDidChange(_ sender: Any) {
      if let amount = amountLabel.text {
         viewModel.didUpdateSellAmount(amount)
      } else {
         viewModel.didUpdateSellAmount("0")
      }
   }
}

// MARK: - UITextField

extension ConverterSellTableViewCell: UITextFieldDelegate {
   func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
      viewModel.didTapTextField()
      viewModel.didUpdateSellAmount("0")
      return true
   }
}

// MARK: - CurrencyItemModelBindableType

extension ConverterSellTableViewCell: CurrencyItemModelBindableType {
   func setItemModel(_ itemModel: CurrencyItemModel) {
      guard let viewModel: ConverterSellTableCellViewModel = itemModel.viewModel() else {
         fatalError("View model mismatched!")
      }
      self.viewModel = viewModel
   }
}

