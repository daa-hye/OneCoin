//
//  Candle.swift
//  OneCoin
//
//  Created by 박다혜 on 4/9/24.
//

import Foundation

struct Candle: Codable, Hashable {
    let market: String
    let candleDatetime: String
    let openingPrice: Double
    let highPrice: Double
    let lowPrice: Double
    let tradePrice: Double

    enum CodingKeys: String, CodingKey {
        case market
        case candleDatetime = "candle_date_time_kst"
        case openingPrice = "opening_price"
        case highPrice = "high_price"
        case lowPrice = "low_price"
        case tradePrice = "trade_price"
    }
}

struct CandleChart: Hashable {
    let market: String
    let name: String
    let englishName: String
    let candles: [Candle]
    let minPrice: Double
    let maxPrice: Double
}
