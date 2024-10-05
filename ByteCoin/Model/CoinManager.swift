//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

import Foundation

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "A398CF98-7407-4EC9-ABF5-C683BECC3CD4"
    
    let currencyArray = ["AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS", "INR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "USD", "ZAR"]
    
    var delegate: CoinManagerDelegate? // Delegate property
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue(apiKey, forHTTPHeaderField: "X-CoinAPI-Key")
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    self.delegate?.didFailWithError(error: error) // Notify delegate of the error
                    return
                }
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        // Notify delegate of the updated price
                        self.delegate?.didUpdatePrice(self, price: bitcoinPrice, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    // Parsing JSON data
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            return lastPrice
        } catch {
            delegate?.didFailWithError(error: error) // Notify delegate if JSON parsing fails
            return nil
        }
    }
}

protocol CoinManagerDelegate {
    func didUpdatePrice(_ coinManager: CoinManager, price: Double, currency: String)
    func didFailWithError(error: Error)
}
