//
//  CurrencyReceiveTableCellViewModel.swift
//  currency-converter
//
//  Created by Tric Rullan on 1/8/20.
//  Copyright © 2020 Tric. All rights reserved.
//

import UIKit

struct CurrencyReceiveTableCellViewModel {
  
  init(currency: String,
       amount: Double,
       onTapUpdateCurrencyReceive: (() -> Void)?) {
    self.currency = currency
    self.amount = amount
    self.onTapUpdateCurrencyReceive = onTapUpdateCurrencyReceive
  }
  
  
  let currency: String?
  let onTapUpdateCurrencyReceive: (() -> Void)?
  
  var amountText: String {
    return "+ \(amount)"
  }
  
  private let amount: Double
}
