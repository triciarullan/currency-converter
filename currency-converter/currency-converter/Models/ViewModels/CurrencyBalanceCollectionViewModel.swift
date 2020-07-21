//
//  CurrencyBalanceCollectionViewModel.swift
//  currency-converter
//
//  Created by Tric Rullan on 1/15/20.
//  Copyright © 2020 Tric. All rights reserved.
//

import UIKit

protocol CurrencyBalanceCollectionViewModelDelegate: class {
   func currencyBalanceCollectionViewModelNeedsReload(_ viewModel: CurrencyBalanceCollectionViewModel)
}

class CurrencyBalanceCollectionViewModel {

   init() {
      initRecordModel()
      sectionModels = makeSectionModels()
   }
   
   var sectionModels = [CurrencyBalanceSectionModel]() {
      didSet {
         delegate?.currencyBalanceCollectionViewModelNeedsReload(self)
      }
   }

   
   weak var delegate: CurrencyBalanceCollectionViewModelDelegate?
   
   // MARK: - Privates
   
   private func initRecordModel() {
     
   }
   
   private func makeSectionModels() -> [CurrencyBalanceSectionModel] {
      var sectionModels = [CurrencyBalanceSectionModel]()

      return sectionModels
   }
   
   // MARK: - Functions
   
   func itemModel(at indexPath: IndexPath) -> CurrencyBalanceItemModel {
      return sectionModels[indexPath.section].items[indexPath.row]
   }
}
