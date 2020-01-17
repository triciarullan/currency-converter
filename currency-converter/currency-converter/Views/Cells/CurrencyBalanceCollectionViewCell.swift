//
//  CurrencyBalanceCollectionViewCell.swift
//  currency-converter
//
//  Created by Tric Rullan on 1/15/20.
//  Copyright © 2020 Tric. All rights reserved.
//

import UIKit

class CurrencyBalanceCollectionViewCell: UICollectionViewCell {

   @IBOutlet private weak var balanceLabel: UILabel!
   
   var viewModel: CurrencyBalanceCollectionCellViewModel! {
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
      balanceLabel.text = viewModel.balance
   }

}

// MARK: - CurrencyBalanceItemModelBindableType

extension CurrencyBalanceCollectionViewCell: CurrencyBalanceItemModelBindableType {
   func setItemModel(_ itemModel: CurrencyBalanceItemModel) {
      guard let viewModel: CurrencyBalanceCollectionCellViewModel = itemModel.viewModel() else {
         fatalError("View model mismatched!")
      }
      self.viewModel = viewModel
   }
}
