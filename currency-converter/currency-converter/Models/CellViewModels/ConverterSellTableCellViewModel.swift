//
//  ConverterSellTableCellViewModel.swift
//  currency-converter
//
//  Created by Tric Rullan on 1/8/20.
//  Copyright © 2020 Tric. All rights reserved.
//

import UIKit

protocol ConverterSellTableCellViewModelDelegate: class {
   func converterSellTableCellViewModelDidTapTextField(_ viewModel: ConverterSellTableCellViewModel)
   func converterSellTableCellViewModelDidUpdateAmount(_ viewModel: ConverterSellTableCellViewModel, amount: Int)
}

class ConverterSellTableCellViewModel {

   weak var delegate: ConverterSellTableCellViewModelDelegate?
   
   init(currency: String,
        amount: Int,
        onTapUpdateCurrencySell: (() -> Void)?) {
      self.currency = currency
      self.amount = amount
      self.onTapUpdateCurrencySell = onTapUpdateCurrencySell
   }
   
   let currency: String?
   let onTapUpdateCurrencySell: (() -> Void)?
   
   var amountText: String {
      return "\(amount)"
   }
   
   func didTapTextField() {
      delegate?.converterSellTableCellViewModelDidTapTextField(self)
   }
   
   func didUpdateSellAmount( _ amountString : String) {
      if let amount = Int(amountString) {
         delegate?.converterSellTableCellViewModelDidUpdateAmount(self, amount: amount)
      } else {
         delegate?.converterSellTableCellViewModelDidUpdateAmount(self, amount: 0)
      }
   }
   
   // MARK: - Privates
   
   private let amount: Int
}
