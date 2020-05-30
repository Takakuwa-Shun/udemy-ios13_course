//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didFailWithError(error: Error) -> Void
    func didUpdateCoin(coinManager: CoinManager, coin: CoinModel) -> Void
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "D3A7D7D6-8FE3-44E4-B349-CB42EA0761A2"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) -> Void {
        let url = baseURL + "/"  + currency + "?apikey=" + apiKey
        performRequest(urlString: url)
    }
    
    func performRequest(urlString: String) -> Void {
        print(urlString)
        guard let url = URL(string: urlString) else {
            return
        }
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: url) { (data, response, error) in
            if let err = error {
                self.delegate?.didFailWithError(error: err)
                return
            }
            
            guard let safeData = data else {
                return
            }
            self.parseJson(safeData)
        }
        task.resume()
    }
    
    func parseJson(_ data: Data) -> Void {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinModel.self, from: data)
            delegate?.didUpdateCoin(coinManager: self, coin: decodedData)
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }
}
