//
//  CurrencyBalanceCollectionViewSectionModel.swift
//  currency-converter
//
//  Created by Tric Rullan on 1/15/20.
//  Copyright © 2020 Tric. All rights reserved.
//

import UIKit

struct CurrencyBalanceSectionModel {
   var items: [CurrencyBalanceItemModel]
}

enum CurrencyBalanceItemModel {
   case balance(viewModel: CurrencyBalanceCollectionCellViewModel)
}

extension CurrencyBalanceItemModel {
   var reuseIdentifier: String {
      switch self {
      case .balance:
         return R.nib.currencyBalanceCollectionViewCell.identifier
      }
   }
   
   func viewModel<T>() -> T? {
      switch self {
      case let .balance(viewModel):
         return viewModel as? T
      }
   }
}

protocol CurrencyBalanceItemModelBindableType {
   func setItemModel(_ itemModel: CurrencyBalanceItemModel)
}
