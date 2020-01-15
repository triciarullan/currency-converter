//
//  CurrencyViewModel.swift
//  currency-converter
//
//  Created by Tric Rullan on 1/8/20.
//  Copyright © 2020 Tric. All rights reserved.
//

import UIKit

protocol CurrencyViewModelDelegate: class {
   func currencyViewModelDidTapCurrencyPicker(_ viewModel: CurrencyViewModel, row: Int)
   func currencyViewModelDidUpdateCurrencyPicker(_ viewModel: CurrencyViewModel, pickerCurrency: PickerCurrency)
   func currencyViewModelDidSubmitCurrencyExchange(_ viewModel: CurrencyViewModel, message: String)
   func currencyViewModelNeedsReloadData(_ viewModel: CurrencyViewModel)
   func currencyViewModelDidTapTextField(_ viewModel: CurrencyViewModel)
}

public enum PickerCurrency {
   case sell
   case receive
   case none
}

enum CurrencyExchange: String, CaseIterable {
   case EUR
   case CAD
   case HKD
   case ISK
   case PHP
   case DKK
   case HUF
   case CZK
   case AUD
   case RON
   case SEK
   case IDR
   case INR
   case BRL
   case RUB
   case HRK
   case JPY
   case THB
   case CHF
   case SGD
   case PLN
   case BGN
   case TRY
   case CNY
   case NOK
   case NZD
   case ZAR
   case USD
   case MXN
   case ILS
   case GBP
   case KRW
   case MYR
}

class CurrencyViewModel {
   
   init(dataService: DataService = DataService()) {
      self.dataService = dataService
      sectionModels = makeSectionModels()
   }
   
   var sectionModels = [CurrencySectionModel]() {
      didSet {
         delegate?.currencyViewModelNeedsReloadData(self)
      }
   }
   
   var pickerCurrency: PickerCurrency = .sell
   var delegate: CurrencyViewModelDelegate?
   var pickerCurrencyData: [String] {
      return pickerData
   }

   
   // MARK: - Privates
   private var dataService: DataService?
   private var currencyModel: CurrencyModel? {
      didSet {
         sectionModels = makeSectionModels()
      }
   }
   private var pickerCurrencySellRowPath: Int = 0 {
      didSet {
         convertSelectedCurrencyExchange()
      }
   }
   private var pickerCurrencyReceiveRowPath: Int = 1 {
      didSet {
         convertSelectedCurrencyExchange()
      }
   }
   private var timer: Timer = Timer()
   private var amountToReceive: Double = 0
   private var amountToSell: Int = 0 {
      didSet {
         delegate?.currencyViewModelNeedsReloadData(self)
      }
   }
   
   private var onTapUpdateCurrencySell: () -> Void {
      return { [weak self] in
         guard let self = self
            else { return }
         
         self.pickerCurrency = .sell
         self.delegate?.currencyViewModelDidTapCurrencyPicker(self,
                                                              row: self.pickerCurrencySellRowPath)
      }
   }
   
   private var onTapUpdateCurrencyReceive: () -> Void {
      return { [weak self] in
         guard let self = self
            else { return }
         
         self.pickerCurrency = .receive
         self.delegate?.currencyViewModelDidTapCurrencyPicker(self,
                                                              row: self.pickerCurrencyReceiveRowPath)
      }
   }
   
   private var pickerData: [String] {
      return CurrencyExchange.allCases.map { $0.rawValue }
   }
   
   private func makeSectionModels() -> [CurrencySectionModel] {
      var sectionModels = [CurrencySectionModel]()
      
      let sellModel = ConverterSellTableCellViewModel(currency: pickerData[pickerCurrencySellRowPath],
                                                      amount: amountToSell,
                                                      onTapUpdateCurrencySell: onTapUpdateCurrencySell)
      sellModel.delegate = self
      sectionModels.append(CurrencySectionModel(items: [.sell(viewModel: sellModel)]))
      
      let receiveModel = ConverterReceiveTableCellViewModel(currency: pickerData[pickerCurrencyReceiveRowPath],
                                                            amount: amountToReceive,
                                                            onTapUpdateCurrencyReceive: onTapUpdateCurrencyReceive)
      sectionModels.append(CurrencySectionModel(items: [.receive(viewModel: receiveModel)]))
      
      return sectionModels
   }
   
   @objc private func updateCurrencyExchange() {
      
      guard let baseCurrency = CurrencyExchange(rawValue: pickerCurrencyData[pickerCurrencySellRowPath])?.rawValue else {
         return
      }
      
      dataService?.getCurrencyExchange(baseCurrency)
         .done { model -> Void in
            self.convertSelectedCurrencyExchange()
            self.currencyModel = model
         }
         .catch { error in
            //Handle error or give feedback to the user
            print(error.localizedDescription)
      }
   }
   
   // MARK: - Functions
   
   func itemModel(at indexPath: IndexPath) -> CurrencyItemModel {
      return sectionModels[indexPath.section].items[indexPath.row]
   }
   
   func didUpdatePickerCurrencySell(row: Int) {
      pickerCurrency = .sell
      pickerCurrencySellRowPath = row
      sectionModels = makeSectionModels()
   }
   
   func didUpdatePickerCurrencyReceive(row: Int) {
      pickerCurrency = .receive
      pickerCurrencyReceiveRowPath = row
      sectionModels = makeSectionModels()
   }
   
   func getCurrencyExchangeFromAPI() {
      timer = Timer.scheduledTimer(timeInterval: 5,
                                   target: self,
                                   selector: #selector(updateCurrencyExchange),
                                   userInfo: nil, repeats: true)
   }
   
   func convertSelectedCurrencyExchange() {
      
      guard let currencySell = CurrencyExchange(rawValue: pickerCurrencyData[pickerCurrencySellRowPath]),
            let currencyReceive = CurrencyExchange(rawValue: pickerCurrencyData[pickerCurrencyReceiveRowPath]),
            let model = currencyModel else {
         return
      }
      
      var convertedRate: Double = 0
      switch currencyReceive {
      case .EUR:
         if let rate = model.rates.eur {
            convertedRate = rate
         }
      case .CAD:
         if let rate = model.rates.cad {
            convertedRate = rate
         }
      case .HKD:
         if let rate = model.rates.hkd {
            convertedRate = rate
         }
      case .ISK:
         if let rate = model.rates.isk {
            convertedRate = rate
         }
      case .PHP:
         if let rate = model.rates.php {
            convertedRate = rate
         }
      case .DKK:
         if let rate = model.rates.dkk {
            convertedRate = rate
         }
      case .HUF:
         if let rate = model.rates.huf {
            convertedRate = rate
         }
      case .CZK:
         if let rate = model.rates.czk {
            convertedRate = rate
         }
      case .AUD:
         if let rate = model.rates.aud {
            convertedRate = rate
         }
      case .RON:
         if let rate = model.rates.ron {
            convertedRate = rate
         }
      case .SEK:
         if let rate = model.rates.sek {
            convertedRate = rate
         }
      case .IDR:
         if let rate = model.rates.idr {
            convertedRate = rate
         }
      case .INR:
         if let rate = model.rates.inr {
            convertedRate = rate
         }
      case .BRL:
         if let rate = model.rates.brl {
            convertedRate = rate
         }
      case .RUB:
         if let rate = model.rates.rub {
            convertedRate = rate
         }
      case .HRK:
         if let rate = model.rates.hrk {
            convertedRate = rate
         }
      case .JPY:
         if let rate = model.rates.jpy {
            convertedRate = rate
         }
      case .THB:
         if let rate = model.rates.thb {
            convertedRate = rate
         }
      case .CHF:
         if let rate = model.rates.chf {
            convertedRate = rate
         }
      case .SGD:
         if let rate = model.rates.sgd {
            convertedRate = rate
         }
      case .PLN:
         if let rate = model.rates.pln {
            convertedRate = rate
         }
      case .BGN:
         if let rate = model.rates.bgn {
            convertedRate = rate
         }
      case .TRY:
         if let rate = model.rates.tur {
            convertedRate = rate
         }
      case .CNY:
         if let rate = model.rates.cny {
            convertedRate = rate
         }
      case .NOK:
         if let rate = model.rates.nok {
            convertedRate = rate
         }
      case .NZD:
         if let rate = model.rates.nzd {
            convertedRate = rate
         }
      case .ZAR:
         if let rate = model.rates.zar {
            convertedRate = rate
         }
      case .USD:
         if let rate = model.rates.usd {
            convertedRate = rate
         }
      case .MXN:
         if let rate = model.rates.mxn {
            convertedRate = rate
         }
      case .ILS:
         if let rate = model.rates.ils {
            convertedRate = rate
         }
      case .GBP:
         if let rate = model.rates.gbp {
            convertedRate = rate
         }
      case .KRW:
         if let rate = model.rates.krw {
            convertedRate = rate
         }
      case .MYR:
         if let rate = model.rates.myr {
            convertedRate = rate
         }
      }
      
      amountToReceive = 0
      amountToReceive = (convertedRate * Double(amountToSell)).rounded(toPlaces: 4)
      sectionModels = makeSectionModels()
   }
}
   
// MARK: - ConverterSellTableCellViewModelDelegate

extension CurrencyViewModel: ConverterSellTableCellViewModelDelegate {
   func converterSellTableCellViewModelDidTapTextField(_ viewModel: ConverterSellTableCellViewModel) {
      delegate?.currencyViewModelDidTapTextField(self)
   }
   
   func converterSellTableCellViewModelDidUpdateAmount(_ viewModel: ConverterSellTableCellViewModel, amount: Int) {
      
      pickerCurrency = .none
      if amount == amountToSell {
         return
      }
      
      amountToSell = amount
      let hello = CurrencyExchange(rawValue: pickerCurrencyData[pickerCurrencySellRowPath])
      
      convertSelectedCurrencyExchange()
   }
}


extension Double {
   /// Rounds the double to decimal places value
   func rounded(toPlaces places:Int) -> Double {
      let divisor = pow(10.0, Double(places))
      return (self * divisor).rounded() / divisor
   }
}
