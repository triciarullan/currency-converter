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

class Currency: Codable {
   var eur: Double? = 0
   var cad: Double? = 0
   var hkd: Double? = 0
   var isk: Double? = 0
   var php: Double? = 0
   var dkk: Double? = 0
   var huf: Double? = 0
   var czk: Double? = 0
   var aud: Double? = 0
   var ron: Double? = 0
   var sek: Double? = 0
   var idr: Double? = 0
   var inr: Double? = 0
   var brl: Double? = 0
   var rub: Double? = 0
   var hrk: Double? = 0
   var jpy: Double? = 0
   var thb: Double? = 0
   var chf: Double? = 0
   var sgd: Double? = 0
   var pln: Double? = 0
   var bgn: Double? = 0
   var tur: Double? = 0
   var cny: Double? = 0
   var nok: Double? = 0
   var nzd: Double? = 0
   var zar: Double? = 0
   var usd: Double? = 0
   var mxn: Double? = 0
   var ils: Double? = 0
   var gbp: Double? = 0
   var krw: Double? = 0
   var myr: Double? = 0
   
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
