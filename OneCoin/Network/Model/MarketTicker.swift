//
//  MarketTicker.swift
//  OneCoin
//
//  Created by 박다혜 on 4/9/24.
//

import Foundation

struct MarketTicker: Hashable, Identifiable {
    var id = UUID()

    let market: String
    let koreanName: String
    let englishName: String
    let tradePrice: Double
    let change: String
    let changePrice: Double
    let changeRate: Double
    let accTradePrice: Double
    let image: URL
    let code: String
}
