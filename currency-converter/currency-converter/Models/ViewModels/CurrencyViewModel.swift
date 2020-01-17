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
   func currencyViewModelDidExchangeCurrencyFail(_ viewModel: CurrencyViewModel, message: String)
   func currencyViewModelNeedsReloadData(_ viewModel: CurrencyViewModel)
   func currencyViewModelDidTapTextField(_ viewModel: CurrencyViewModel)
   func currencyViewModelDidExchangeCurrencySuccess(_ viewModel: CurrencyViewModel, currency: Currency, transactionCount: Int, message: String)
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

enum TransactionErrorType {
   case none
   case sameCurrency
   case insufficientBalance
   case amountToSellIsZero
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
   weak var delegate: CurrencyViewModelDelegate?
   var pickerCurrencyData: [String] {
      return pickerData
   }
   
   var recordModel: Currency?
   
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
   
   private var transactionError: TransactionErrorType = .none
   private var transactionErrorTypeMessage: String {
      var message = R.string.localizable.pleaseTryAgain()
      switch transactionError {
      case .insufficientBalance:
         message = R.string.localizable.yourBalanceIsInsufficientPleaseTryAgain()
      case .sameCurrency:
         message = R.string.localizable.youCannotConvertTheSameCurrencyPleaseTryAgain()
      case .amountToSellIsZero:
         message = R.string.localizable.yourAmountToSellIsInvalidPleaseTryAgain()
      default: break
      }
      return message
   }
   
   private var transactionCount: Int = 0
   private var timer: Timer = Timer()
   private var amountToReceive: Double = 0
   private var amountToSell: Int = 0 {
      didSet {
         delegate?.currencyViewModelNeedsReloadData(self)
      }
   }
   
   private var amountToSellDouble: Double {
      return Double(amountToSell)
   }
   
   private var amountToReceiveDouble: Double {
      return Double(amountToReceive)
   }
   
   private var transferFee: Double {
      return amountToSellDouble * 0.007
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
   
   private var currencySell: CurrencyExchange? {
      return CurrencyExchange(rawValue: pickerCurrencyData[pickerCurrencySellRowPath])
   }
   
   private var currencyReceive: CurrencyExchange? {
      return CurrencyExchange(rawValue: pickerCurrencyData[pickerCurrencyReceiveRowPath])
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
   
   private func isError() -> Bool {
      guard let currencySell = currencySell,
            let currencyReceive = currencyReceive else {
            return false
      }
      
      if currencySell == currencyReceive {
         transactionError = .sameCurrency
         return true
      } else if amountToSell == 0 {
         transactionError = .amountToSellIsZero
         return true
      }
      
      return false
   }
   
   private func isBalanceSufficient(balance: Double) -> Bool {
      if transactionCount > 5 {
         let availBalance = balance - amountToSellDouble - transferFee
         if availBalance < 0 {
            transactionError = .insufficientBalance
            return false
         }
      } else {
         let availBalance = balance - amountToSellDouble
         if availBalance < 0 {
            transactionError = .insufficientBalance
            return false
         }
      }
      return true
   }
   
   private func displayTransactionErrorMessage() {
      delegate?.currencyViewModelDidExchangeCurrencyFail(self,
                                                         message: transactionErrorTypeMessage)
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
   
   func submitSelectedCurrencyExchanage() {
      
      guard !isError() else {
         displayTransactionErrorMessage()
         return
      }
      
      convertSelectedCurrencyExchange()
      
      guard let currencySell = currencySell,
         let currencyReceive = currencyReceive,
         let model = recordModel else {
            return
      }
      
      var isExchangeCurrencySuccess = false
      switch currencySell {
      case .EUR:
         if var balance = model.eur,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.eur = balance
            isExchangeCurrencySuccess = true
         }
      case .CAD:
         if var balance = model.cad,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.cad = balance
            isExchangeCurrencySuccess = true
         }
      case .HKD:
         if var balance = model.hkd,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.hkd = balance
            isExchangeCurrencySuccess = true
         }
      case .ISK:
         if var balance = model.isk,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.isk = balance
            isExchangeCurrencySuccess = true
         }
      case .PHP:
         if var balance = model.php,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.php = balance
            isExchangeCurrencySuccess = true
         }
      case .DKK:
         if var balance = model.dkk,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.dkk = balance
            isExchangeCurrencySuccess = true
         }
      case .HUF:
         if var balance = model.huf,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.huf = balance
            isExchangeCurrencySuccess = true
         }
      case .CZK:
         if var balance = model.czk,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.czk = balance
            isExchangeCurrencySuccess = true
         }
      case .AUD:
         if var balance = model.aud,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.aud = balance
            isExchangeCurrencySuccess = true
         }
      case .RON:
         if var balance = model.ron,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.ron = balance
            isExchangeCurrencySuccess = true
         }
      case .SEK:
         if var balance = model.sek,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.sek = balance
            isExchangeCurrencySuccess = true
         }
      case .IDR:
         if var balance = model.idr,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.idr = balance
            isExchangeCurrencySuccess = true
         }
      case .INR:
         if var balance = model.inr,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.inr = balance
            isExchangeCurrencySuccess = true
         }
      case .BRL:
         if var balance = model.brl,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.brl = balance
            isExchangeCurrencySuccess = true
         }
      case .RUB:
         if var balance = model.rub,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.rub = balance
            isExchangeCurrencySuccess = true
         }
      case .HRK:
         if var balance = model.hrk,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.hrk = balance
            isExchangeCurrencySuccess = true
         }
      case .JPY:
         if var balance = model.jpy,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.jpy = balance
            isExchangeCurrencySuccess = true
         }
      case .THB:
         if var balance = model.thb,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.thb = balance
            isExchangeCurrencySuccess = true
         }
      case .CHF:
         if var balance = model.chf,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.chf = balance
            isExchangeCurrencySuccess = true
         }
      case .SGD:
         if var balance = model.sgd,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.sgd = balance
            isExchangeCurrencySuccess = true
         }
      case .PLN:
         if var balance = model.pln,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.pln = balance
            isExchangeCurrencySuccess = true
         }
      case .BGN:
         if var balance = model.bgn,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.bgn = balance
            isExchangeCurrencySuccess = true
         }
      case .TRY:
         if var balance = model.tur,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.tur = balance
            isExchangeCurrencySuccess = true
         }
      case .CNY:
         if var balance = model.cny,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.cny = balance
            isExchangeCurrencySuccess = true
         }
      case .NOK:
         if var balance = model.nok,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.nok = balance
            isExchangeCurrencySuccess = true
         }
      case .NZD:
         if var balance = model.nzd,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.nzd = balance
            isExchangeCurrencySuccess = true
         }
      case .ZAR:
         if var balance = model.zar,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.zar = balance
            isExchangeCurrencySuccess = true
         }
      case .USD:
         if var balance = model.usd,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.usd = balance
            isExchangeCurrencySuccess = true
         }
      case .MXN:
         if var balance = model.mxn,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.mxn = balance
            isExchangeCurrencySuccess = true
         }
      case .ILS:
         if var balance = model.ils,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.ils = balance
            isExchangeCurrencySuccess = true
         }
      case .GBP:
         if var balance = model.gbp,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.gbp = balance
            isExchangeCurrencySuccess = true
         }
      case .KRW:
         if var balance = model.krw,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.krw = balance
            isExchangeCurrencySuccess = true
         }
      case .MYR:
         if var balance = model.myr,
            isBalanceSufficient(balance: balance) {
            balance -= amountToSellDouble
            model.myr = balance
            isExchangeCurrencySuccess = true
         }
      }
      
      guard isExchangeCurrencySuccess else {
         delegate?.currencyViewModelDidExchangeCurrencyFail(self,
                                                            message: transactionErrorTypeMessage)
         
         return
      }
      
      switch currencyReceive {
      case .EUR:
         if var balance = model.eur {
            balance += amountToReceive
            model.eur = balance.rounded(toPlaces: 4)
         }
      case .CAD:
         if var balance = model.cad {
            balance += amountToReceive
            model.cad = balance.rounded(toPlaces: 4)
         }
      case .HKD:
         if var balance = model.hkd {
            balance += amountToReceive
            model.hkd = balance.rounded(toPlaces: 4)
         }
      case .ISK:
         if var balance = model.isk {
            balance += amountToReceive
            model.isk = balance.rounded(toPlaces: 4)
         }
      case .PHP:
         if var balance = model.php {
            balance += amountToReceive
            model.php = balance.rounded(toPlaces: 4)
         }
      case .DKK:
         if var balance = model.dkk {
            balance += amountToReceive
            model.dkk = balance.rounded(toPlaces: 4)
         }
      case .HUF:
         if var balance = model.huf {
            balance += amountToReceive
            model.huf = balance.rounded(toPlaces: 4)
         }
      case .CZK:
         if var balance = model.czk {
            balance += amountToReceive
            model.czk = balance.rounded(toPlaces: 4)
         }
      case .AUD:
         if var balance = model.aud {
            balance += amountToReceive
            model.aud = balance.rounded(toPlaces: 4)
         }
      case .RON:
         if var balance = model.ron {
            balance += amountToReceive
            model.ron = balance.rounded(toPlaces: 4)
         }
      case .SEK:
         if var balance = model.sek {
            balance += amountToReceive
            model.sek = balance.rounded(toPlaces: 4)
         }
      case .IDR:
         if var balance = model.idr {
            balance += amountToReceive
            model.idr = balance.rounded(toPlaces: 4)
         }
      case .INR:
         if var balance = model.inr {
            balance += amountToReceive
            model.inr = balance.rounded(toPlaces: 4)
         }
      case .BRL:
         if var balance = model.brl {
            balance += amountToReceive
            model.brl = balance.rounded(toPlaces: 4)
         }
      case .RUB:
         if var balance = model.rub {
            balance += amountToReceive
            model.rub = balance.rounded(toPlaces: 4)
         }
      case .HRK:
         if var balance = model.hrk {
            balance += amountToReceive
            model.hrk = balance.rounded(toPlaces: 4)
         }
      case .JPY:
         if var balance = model.jpy {
            balance += amountToReceive
            model.jpy = balance.rounded(toPlaces: 4)
         }
      case .THB:
         if var balance = model.thb {
            balance += amountToReceive
            model.thb = balance.rounded(toPlaces: 4)
         }
      case .CHF:
         if var balance = model.chf {
            balance += amountToReceive
            model.chf = balance.rounded(toPlaces: 4)
         }
      case .SGD:
         if var balance = model.sgd {
            balance += amountToReceive
            model.sgd = balance.rounded(toPlaces: 4)
         }
      case .PLN:
         if var balance = model.pln {
            balance += amountToReceive
            model.pln = balance.rounded(toPlaces: 4)
         }
      case .BGN:
         if var balance = model.bgn {
            balance += amountToReceive
            model.bgn = balance.rounded(toPlaces: 4)
         }
      case .TRY:
         if var balance = model.tur {
            balance += amountToReceive
            model.tur = balance.rounded(toPlaces: 4)
         }
      case .CNY:
         if var balance = model.cny {
            balance += amountToReceive
            model.cny = balance.rounded(toPlaces: 4)
         }
      case .NOK:
         if var balance = model.nok {
            balance += amountToReceive
            model.nok = balance.rounded(toPlaces: 4)
         }
      case .NZD:
         if var balance = model.nzd {
            balance += amountToReceive
            model.nzd = balance.rounded(toPlaces: 4)
         }
      case .ZAR:
         if var balance = model.zar {
            balance += amountToReceive
            model.zar = balance.rounded(toPlaces: 4)
         }
      case .USD:
         if var balance = model.usd {
            balance += amountToReceive
            model.usd = balance.rounded(toPlaces: 4)
         }
      case .MXN:
         if var balance = model.mxn {
            balance += amountToReceive
            model.mxn = balance.rounded(toPlaces: 4)
         }
      case .ILS:
         if var balance = model.ils {
            balance += amountToReceive
            model.ils = balance.rounded(toPlaces: 4)
         }
      case .GBP:
         if var balance = model.gbp {
            balance += amountToReceive
            model.gbp = balance.rounded(toPlaces: 4)
         }
      case .KRW:
         if var balance = model.krw {
            balance += amountToReceive
            model.krw = balance.rounded(toPlaces: 4)
         }
      case .MYR:
         if var balance = model.myr {
            balance += amountToReceive
            model.myr = balance.rounded(toPlaces: 4)
         }
      }
      
      var message = R.string.localizable.youHaveSuccessfullyConvertedToKindlyCheckYourNewBalance("\(amountToSell) \(currencySell.rawValue)", "\(amountToReceive) \(currencyReceive.rawValue)")
      if transactionCount > 5 {
         message = R.string.localizable.youHaveSuccessfullyConvertedToCommissionFeeIsKindlyCheckYourNewBalance("\(amountToSell) \(currencySell.rawValue)", "\(amountToReceive) \(currencyReceive.rawValue)", "\(transferFee) \(currencySell.rawValue)")
      }
      
      delegate?.currencyViewModelDidExchangeCurrencySuccess(self, currency: model,
                                                            transactionCount: transactionCount,
                                                            message: message)
      amountToSell = 0
      amountToReceive = 0
      pickerCurrency = .sell
      transactionCount += 1
      transactionError = .none
      
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
      convertSelectedCurrencyExchange()
   }
}
