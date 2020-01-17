//
//  CurrencyBalanceCollectionCellViewModel.swift
//  currency-converter
//
//  Created by Tric Rullan on 1/15/20.
//  Copyright © 2020 Tric. All rights reserved.
//

import UIKit

struct CurrencyBalanceCollectionCellViewModel {

   init(amount: Double, currency: String) {
      self.amount = amount
      self.currency = currency
   }
   
   private let amount: Double
   private let currency: String
   
   var balance: String {
      return "\(amount) \(currency)"
   }
}
