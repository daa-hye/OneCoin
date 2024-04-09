//
//  Ticker.swift
//  OneCoin
//
//  Created by 박다혜 on 4/9/24.
//

import Foundation

struct Ticker: Codable {
    let code: String
    let tradePrice: Double
    let change: String
    let changePrice: Double
    let changeRate: Double
    let accTradePrice: Double

    enum CodingKeys: String, CodingKey {
        case code
        case tradePrice = "trade_price"
        case change
        case changePrice = "signed_change_price"
        case changeRate = "signed_change_rate"
        case accTradePrice = "acc_trade_price_24h"
    }
}
