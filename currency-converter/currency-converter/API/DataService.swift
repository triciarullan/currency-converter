//
//  DataService.swift
//  currency-converter
//
//  Created by Tric Rullan on 1/8/20.
//  Copyright © 2020 Tric. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

struct DataService {
   
   // MARK: - Singleton
   static let shared = DataService()
   
   // MARK: - URL
   private var trackURL = "https://api.exchangeratesapi.io/latest?base=EUR"
   
   // MARK: - Services
   
   func getCurrencyExchange() -> Promise<CurrencyModel> {
      return Promise { seal in
         Alamofire.request(trackURL)
            .validate()
            .responseJSON { response in
               switch response.result {
               case .success:
                  guard let data = response.data else { return }
                  do {
                     let decoder = JSONDecoder()
                     let trackModel = try decoder.decode(CurrencyModel.self, from: data)
                     seal.fulfill(trackModel)
                  } catch let jsonError as NSError {
                     print("json error: \(jsonError.localizedDescription)")
                  }
               case .failure(let error):
                  seal.reject(error)
               }
         }
      }
   }
   
}
