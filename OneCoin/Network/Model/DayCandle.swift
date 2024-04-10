//
//  DayCandle.swift
//  OneCoin
//
//  Created by 박다혜 on 4/9/24.
//

import Foundation

struct DayCandle: Codable {
    let market: String
    let openingPrice: Double
    let highPrice: Double
    let lowPrice: Double
    let changePrice: Double
    let changeRate: Double

    enum CodingKeys: String, CodingKey {
        case market
        case openingPrice = "opening_price"
        case highPrice = "high_price"
        case lowPrice = "low_price"
        case changePrice = "change_price"
        case changeRate = "change_rate"
    }
}
