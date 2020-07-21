//
//  CurrencyModel.swift
//  currency-converter
//
//  Created by Tric Rullan on 1/8/20.
//  Copyright © 2020 Tric. All rights reserved.
//

import UIKit

struct Currency: Codable {
  let base: String
  let rates: [String: Double]
}
