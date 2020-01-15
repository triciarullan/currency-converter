//
//  CurrencySectionModel.swift
//  currency-converter
//
//  Created by Tric Rullan on 1/8/20.
//  Copyright © 2020 Tric. All rights reserved.
//

import UIKit

struct CurrencySectionModel {
   var items: [CurrencyItemModel]
}

enum CurrencyItemModel {
   case sell(viewModel: ConverterSellTableCellViewModel)
   case receive(viewModel: ConverterReceiveTableCellViewModel)
   
}

extension CurrencyItemModel {
   var reuseIdentifier: String {
      switch self {
      case .sell:
         return R.nib.converterSellTableViewCell.identifier
      case .receive:
         return R.nib.converterReceiveTableViewCell.identifier
      }
   }
   
   func viewModel<T>() -> T? {
      switch self {
      case let .sell(viewModel):
         return viewModel as? T
      case .receive(let viewModel):
         return viewModel as? T
      }
   }
}

protocol CurrencyItemModelBindableType {
   func setItemModel(_ itemModel: CurrencyItemModel)
}
