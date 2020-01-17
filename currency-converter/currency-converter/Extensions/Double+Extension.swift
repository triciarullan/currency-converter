//
//  Double+Extension.swift
//  currency-converter
//
//  Created by Tric Rullan on 1/17/20.
//  Copyright © 2020 Tric. All rights reserved.
//

import UIKit

extension Double {
   /// Rounds the double to decimal places value
   func rounded(toPlaces places:Int) -> Double {
      let divisor = pow(10.0, Double(places))
      return (self * divisor).rounded() / divisor
   }
}
