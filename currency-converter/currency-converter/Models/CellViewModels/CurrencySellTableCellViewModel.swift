//
//  CurrencySellTableCellViewModel.swift
//  currency-converter
//
//  Created by Tric Rullan on 1/8/20.
//  Copyright © 2020 Tric. All rights reserved.
//

import UIKit

protocol CurrencySellTableCellViewModelDelegate: class {
   func converterSellTableCellViewModelDidTapTextField(_ viewModel: CurrencySellTableCellViewModel)
   func converterSellTableCellViewModelDidUpdateAmount(_ viewModel: CurrencySellTableCellViewModel, amount: Int)
}

class CurrencySellTableCellViewModel {

   weak var delegate: CurrencySellTableCellViewModelDelegate?
   
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
