//
//  CurrencyBalanceCollectionViewModel.swift
//  currency-converter
//
//  Created by Tric Rullan on 1/15/20.
//  Copyright © 2020 Tric. All rights reserved.
//

import UIKit

protocol CurrencyBalanceCollectionViewModelDelegate: class {
   func currencyBalanceCollectionViewModelDidUpdate(viewModel model: CurrencyBalanceCollectionViewModel,
                                                    recordCurrency: Currency)
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
         delegate?.currencyBalanceCollectionViewModelDidUpdate(viewModel: self,
                                                               recordCurrency: recordCurrency)
      }
   }
   
   var recordCurrency: Currency! {
      didSet {
         sectionModels = makeSectionModels()
      }
   }
   
   weak var delegate: CurrencyBalanceCollectionViewModelDelegate?
   
   // MARK: - Privates
   
   private func initRecordModel() {
      recordCurrency = Currency()
      recordCurrency.eur = 1000
   }
   
   private func makeSectionModels() -> [CurrencyBalanceSectionModel] {
      var sectionModels = [CurrencyBalanceSectionModel]()
      
      guard let model = recordCurrency else {
         return sectionModels
      }
      
      let eur = CurrencyBalanceCollectionCellViewModel(amount:model.eur ?? 0,
                                                       currency: Currency.CodingKeys.eur.rawValue)
      let cad = CurrencyBalanceCollectionCellViewModel(amount:model.cad ?? 0,
                                                       currency: Currency.CodingKeys.cad.rawValue)
      let hkd = CurrencyBalanceCollectionCellViewModel(amount:model.hkd ?? 0,
                                                       currency: Currency.CodingKeys.hkd.rawValue)
      let isk = CurrencyBalanceCollectionCellViewModel(amount:model.isk ?? 0,
                                                       currency: Currency.CodingKeys.isk.rawValue)
      let php = CurrencyBalanceCollectionCellViewModel(amount:model.php ?? 0,
                                                       currency: Currency.CodingKeys.php.rawValue)
      let dkk = CurrencyBalanceCollectionCellViewModel(amount:model.dkk ?? 0,
                                                       currency: Currency.CodingKeys.dkk.rawValue)
      let huf = CurrencyBalanceCollectionCellViewModel(amount:model.huf ?? 0,
                                                       currency: Currency.CodingKeys.huf.rawValue)
      let czk = CurrencyBalanceCollectionCellViewModel(amount:model.czk ?? 0,
                                                       currency: Currency.CodingKeys.czk.rawValue)
      let aud = CurrencyBalanceCollectionCellViewModel(amount:model.aud ?? 0,
                                                       currency: Currency.CodingKeys.aud.rawValue)
      let ron = CurrencyBalanceCollectionCellViewModel(amount:model.ron ?? 0,
                                                       currency: Currency.CodingKeys.ron.rawValue)
      let sek = CurrencyBalanceCollectionCellViewModel(amount:model.sek ?? 0,
                                                       currency: Currency.CodingKeys.sek.rawValue)
      let idr = CurrencyBalanceCollectionCellViewModel(amount:model.idr ?? 0,
                                                       currency: Currency.CodingKeys.idr.rawValue)
      let inr = CurrencyBalanceCollectionCellViewModel(amount:model.inr ?? 0,
                                                       currency: Currency.CodingKeys.inr.rawValue)
      let brl = CurrencyBalanceCollectionCellViewModel(amount:model.brl ?? 0,
                                                       currency: Currency.CodingKeys.brl.rawValue)
      let rub = CurrencyBalanceCollectionCellViewModel(amount:model.rub ?? 0,
                                                       currency: Currency.CodingKeys.rub.rawValue)
      let hrk = CurrencyBalanceCollectionCellViewModel(amount:model.hrk ?? 0,
                                                       currency: Currency.CodingKeys.hrk.rawValue)
      let jpy = CurrencyBalanceCollectionCellViewModel(amount:model.jpy ?? 0,
                                                       currency: Currency.CodingKeys.jpy.rawValue)
      let thb = CurrencyBalanceCollectionCellViewModel(amount:model.thb ?? 0,
                                                       currency: Currency.CodingKeys.thb.rawValue)
      let chf = CurrencyBalanceCollectionCellViewModel(amount:model.chf ?? 0,
                                                       currency: Currency.CodingKeys.chf.rawValue)
      let sgd = CurrencyBalanceCollectionCellViewModel(amount:model.sgd ?? 0,
                                                       currency: Currency.CodingKeys.sgd.rawValue)
      let pln = CurrencyBalanceCollectionCellViewModel(amount:model.pln ?? 0,
                                                       currency: Currency.CodingKeys.pln.rawValue)
      let bgn = CurrencyBalanceCollectionCellViewModel(amount:model.bgn ?? 0,
                                                       currency: Currency.CodingKeys.bgn.rawValue)
      let tur = CurrencyBalanceCollectionCellViewModel(amount:model.tur ?? 0,
                                                       currency: Currency.CodingKeys.tur.rawValue)
      let cny = CurrencyBalanceCollectionCellViewModel(amount:model.cny ?? 0,
                                                       currency: Currency.CodingKeys.cny.rawValue)
      let nok = CurrencyBalanceCollectionCellViewModel(amount:model.nok ?? 0,
                                                       currency: Currency.CodingKeys.nok.rawValue)
      let nzd = CurrencyBalanceCollectionCellViewModel(amount:model.nzd ?? 0,
                                                       currency: Currency.CodingKeys.nzd.rawValue)
      let zar = CurrencyBalanceCollectionCellViewModel(amount:model.zar ?? 0,
                                                       currency: Currency.CodingKeys.zar.rawValue)
      let usd = CurrencyBalanceCollectionCellViewModel(amount:model.usd ?? 0,
                                                       currency: Currency.CodingKeys.usd.rawValue)
      let mxn = CurrencyBalanceCollectionCellViewModel(amount:model.mxn ?? 0,
                                                       currency: Currency.CodingKeys.mxn.rawValue)
      let ils = CurrencyBalanceCollectionCellViewModel(amount:model.ils ?? 0,
                                                       currency: Currency.CodingKeys.ils.rawValue)
      let gbp = CurrencyBalanceCollectionCellViewModel(amount:model.gbp ?? 0,
                                                       currency: Currency.CodingKeys.gbp.rawValue)
      let krw = CurrencyBalanceCollectionCellViewModel(amount:model.krw ?? 0,
                                                       currency: Currency.CodingKeys.krw.rawValue)
      let myr = CurrencyBalanceCollectionCellViewModel(amount:model.myr ?? 0,
                                                       currency: Currency.CodingKeys.myr.rawValue)
      
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: eur)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: cad)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: hkd)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: isk)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: php)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: dkk)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: huf)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: czk)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: aud)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: ron)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: sek)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: idr)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: inr)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: brl)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: rub)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: hrk)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: jpy)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: thb)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: chf)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: sgd)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: pln)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: bgn)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: tur)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: cny)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: nok)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: nzd)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: zar)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: usd)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: mxn)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: ils)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: gbp)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: krw)]))
      sectionModels.append(CurrencyBalanceSectionModel(items: [.balance(viewModel: myr)]))
 
      return sectionModels
   }
   
   // MARK: - Functions
   
   func itemModel(at indexPath: IndexPath) -> CurrencyBalanceItemModel {
      return sectionModels[indexPath.section].items[indexPath.row]
   }
}
