//
//  CoinData.swift
//  ByteCoin
//
//  Created by Yehia Khamees on 10/5/24.
//  Copyright © 2024 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Codable {
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}

struct Coin: Codable {
    let name: String
    let symbol: String
    let price: Double
    let marketCap: Double
    let volume: Double
    let change: Double
    let changePercent: Double
    let image: String
}
