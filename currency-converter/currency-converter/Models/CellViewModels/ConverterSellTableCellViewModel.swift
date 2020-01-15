//
//  ConverterSellTableCellViewModel.swift
//  currency-converter
//
//  Created by Tric Rullan on 1/8/20.
//  Copyright © 2020 Tric. All rights reserved.
//

import UIKit

protocol ConverterSellTableCellViewModelDelegate: class {
   func converterSellTableCellViewModelDidUpdateAmount( _ : Double)
}

class ConverterSellTableCellViewModel {

   weak var delegate: ConverterSellTableCellViewModelDelegate?
   
   init(currency: String,
        amount: Double,
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
   
   func didUpdateSellAmount( _ amountString : String) {
      if let amount = Double(amountString) {
         delegate?.converterSellTableCellViewModelDidUpdateAmount(amount)
      }
   }
   
   // MARK: - Privates
   
   private let amount: Double
}
