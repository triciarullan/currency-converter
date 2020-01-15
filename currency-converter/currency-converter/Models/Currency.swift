//
//  CurrencyModel.swift
//  currency-converter
//
//  Created by Tric Rullan on 1/8/20.
//  Copyright © 2020 Tric. All rights reserved.
//

import UIKit

struct CurrencyModel: Codable {
   let base: String
   let rates: Currency
   
   enum CodingKeys: String, CodingKey {
      case base
      case rates
   }
}

// MARK: - Feature

struct Currency: Codable {
   let eur: Double?
   let cad: Double?
   let hkd: Double?
   let isk: Double?
   let php: Double?
   let dkk: Double?
   let huf: Double?
   let czk: Double?
   let aud: Double?
   let ron: Double?
   let sek: Double?
   let idr: Double?
   let inr: Double?
   let brl: Double?
   let rub: Double?
   let hrk: Double?
   let jpy: Double?
   let thb: Double?
   let chf: Double?
   let sgd: Double?
   let pln: Double?
   let bgn: Double?
   let tur: Double?
   let cny: Double?
   let nok: Double?
   let nzd: Double?
   let zar: Double?
   let usd: Double?
   let mxn: Double?
   let ils: Double?
   let gbp: Double?
   let krw: Double?
   let myr: Double?
   
   enum CodingKeys: String, CodingKey {
      case eur = "EUR"
      case cad = "CAD"
      case hkd = "HKD"
      case isk = "ISK"
      case php = "PHP"
      case dkk = "DKK"
      case huf = "HUF"
      case czk = "CZK"
      case aud = "AUD"
      case ron = "RON"
      case sek = "SEK"
      case idr = "IDR"
      case inr = "INR"
      case brl = "BRL"
      case rub = "RUB"
      case hrk = "HRK"
      case jpy = "JPY"
      case thb = "THB"
      case chf = "CHF"
      case sgd = "SGD"
      case pln = "PLN"
      case bgn = "BGN"
      case tur = "TRY"
      case cny = "CNY"
      case nok = "NOK"
      case nzd = "NZD"
      case zar = "ZAR"
      case usd = "USD"
      case mxn = "MXN"
      case ils = "ILS"
      case gbp = "GBP"
      case krw = "KRW"
      case myr = "MYR"
   }
}


struct CurrencyExchangeModel {
   var model: CurrencyModel?
   let fee: Double = 0.007
   var transactionCount: Int = 0
}
