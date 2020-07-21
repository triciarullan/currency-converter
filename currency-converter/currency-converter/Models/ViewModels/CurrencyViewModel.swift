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
  func currencyViewModelDidReloadData(_ viewModel: CurrencyViewModel)
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
    
    getCurrencyExchangeFromAPI()
  }
  
  var sectionModels = [CurrencySectionModel]() {
    didSet {
      delegate?.currencyViewModelNeedsReloadData(self)
      delegate?.currencyViewModelDidReloadData(self)
    }
  }
  
  var pickerCurrency: PickerCurrency = .sell
  weak var delegate: CurrencyViewModelDelegate?
  
  var pickerCurrencyData: [String]? {
    guard let pickerData = pickerData else {
      return nil
    }
    return pickerData
  }
  
  
  // MARK: - Privates
  
  private var dataService: DataService?
  private var currencyListModel: [CurrencyModel]?
  private var currency: Currency? {
    didSet {
      sectionModels = makeSectionModels()
      delegate?.currencyViewModelNeedsReloadData(self)
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
  
  private var hasTransferFee: Bool {
    return transactionCount >= 5
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
    return (amountToSellDouble * 0.007).rounded(toPlaces: 4)
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
  
  private var pickerData: [String]? {
    guard let currencyListModel = currencyListModel else {
      return nil
    }
    return currencyListModel.map( { $0.name }) as? [String]
    //CurrencyExchange.allCases.map { $0.rawValue }
  }
  
  private var currencySell: CurrencyExchange? {
    return .AUD
    //return CurrencyExchange(rawValue: pickerCurrencyData?[pickerCurrencySellRowPath])
  }
  
  private var currencyReceive: CurrencyExchange? {
    return .AUD
   // return CurrencyExchange(rawValue: pickerCurrencyData?[pickerCurrencyReceiveRowPath])
  }
  
  private func makeSectionModels() -> [CurrencySectionModel] {
    var sectionModels = [CurrencySectionModel]()
    
    guard let pickerData = pickerData else {
      return sectionModels
    }

    let sellModel = CurrencySellTableCellViewModel(currency: pickerData[pickerCurrencySellRowPath],
                                                   amount: amountToSell,
                                                   onTapUpdateCurrencySell: onTapUpdateCurrencySell)
    sellModel.delegate = self
    sectionModels.append(CurrencySectionModel(items: [.sell(viewModel: sellModel)]))
    
    let receiveModel = CurrencyReceiveTableCellViewModel(currency: pickerData[pickerCurrencyReceiveRowPath],
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
    if transactionCount >= 5 {
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
    
    dataService?.getCurrencyExchange("EUR")
      .done { model -> Void in
        self.currency = model
        
        self.currencyListModel = [CurrencyModel]()
        if let currency = self.currency {
          for (key, value) in currency.rates {
            let rate = Decimal(value)
            let model = CurrencyModel(name: key, rate: rate, balance: 0)
            self.currencyListModel?.append(model)
          }
        }
        
        self.sectionModels = self.makeSectionModels()
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
  
  private func getCurrencyExchangeFromAPI() {
    timer = Timer.scheduledTimer(timeInterval: 5,
                                 target: self,
                                 selector: #selector(updateCurrencyExchange),
                                 userInfo: nil, repeats: false)
  }
  
  func submitSelectedCurrencyExchanage() {
    
    
  }
  
  func convertSelectedCurrencyExchange() {
    
  }
}

// MARK: - ConverterSellTableCellViewModelDelegate

extension CurrencyViewModel: CurrencySellTableCellViewModelDelegate {
  func converterSellTableCellViewModelDidTapTextField(_ viewModel: CurrencySellTableCellViewModel) {
    delegate?.currencyViewModelDidTapTextField(self)
  }
  
  func converterSellTableCellViewModelDidUpdateAmount(_ viewModel: CurrencySellTableCellViewModel, amount: Int) {
    
    pickerCurrency = .none
    if amount == amountToSell {
      return
    }
    
    amountToSell = amount
    convertSelectedCurrencyExchange()
  }
}
