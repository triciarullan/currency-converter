//
//  CurrencyViewModel.swift
//  currency-converter
//
//  Created by Tric Rullan on 1/8/20.
//  Copyright © 2020 Tric. All rights reserved.
//

import UIKit

protocol CurrencyViewModelDelegate: class {
   func currencyViewModelDidTapCurrencyPicker(_ : CurrencyViewModel, row: Int)
   func currencyViewModelDidUpdateCurrencyPicker(_ : CurrencyViewModel, pickerCurrency: PickerCurrency)
}

public enum PickerCurrency {
   case sell
   case receive
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
         //delegate?.trackViewModelNeedsReloadData(self)
      }
   }
   
   var pickerCurrency: PickerCurrency = .sell
   var delegate: CurrencyViewModelDelegate?
   var pickerCurrencyData: [String] {
      return pickerData
   }

   
   // MARK: - Privates
   private var dataService: DataService?
   private var currencyModel: CurrencyModel?
   private var pickerCurrencySellRowPath: Int = 0
   private var pickerCurrencyReceiveRowPath: Int = 0
   private var timer: Timer = Timer()
   
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
                                                      amount: 1000,
                                                      onTapUpdateCurrencySell: onTapUpdateCurrencySell)
      sellModel.delegate = self
      sectionModels.append(CurrencySectionModel(items: [.sell(viewModel: sellModel)]))
      
      let receiveModel = ConverterReceiveTableCellViewModel(currency: pickerData[pickerCurrencyReceiveRowPath],
                                                            amount: 1.2,
                                                            onTapUpdateCurrencyReceive: onTapUpdateCurrencyReceive)
      sectionModels.append(CurrencySectionModel(items: [.receive(viewModel: receiveModel)]))
      
      return sectionModels
   }
   
   private func convertCurrencyExchange() {
      
   }
   
   
   @objc private func updateCurrencyExchange() {
      dataService?.getCurrencyExchange()
         .done { model -> Void in
            self.currencyModel = model
            
            print("❤️ \(model)")
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
}
   
// MARK: - ConverterSellTableCellViewModelDelegate

extension CurrencyViewModel: ConverterSellTableCellViewModelDelegate {
   func converterSellTableCellViewModelDidUpdateAmount(_ amount: Double) {
      print("HELLO")
      
      
      let hello = CurrencyExchange(rawValue: pickerCurrencyData[pickerCurrencySellRowPath])
      print(hello)
      
      
   }
}
