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
    let changePrice, changeRate: Double
    let accTradePrice, accTradeVolume: Double
    let highest52WeekPrice, lowest52WeekPrice: Double
    let highest52WeekDate, lowest52WeekDate: String

    enum CodingKeys: String, CodingKey {
        case code
        case tradePrice = "trade_price"
        case change
        case changePrice = "signed_change_price"
        case changeRate = "signed_change_rate"
        case accTradePrice = "acc_trade_price_24h"
        case accTradeVolume = "acc_trade_volume_24h"
        case highest52WeekPrice = "highest_52_week_price"
        case lowest52WeekPrice = "lowest_52_week_price"
        case highest52WeekDate = "highest_52_week_date"
        case lowest52WeekDate = "lowest_52_week_date"
    }
}
