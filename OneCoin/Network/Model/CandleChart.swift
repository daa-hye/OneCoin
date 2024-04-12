//
//  CandleChart.swift
//  OneCoin
//
//  Created by 박다혜 on 4/12/24.
//

import Foundation

struct CandleChart: Hashable {
    let name: String
    let candles: [Candle]
    let minPrice: Double
    let maxPrice: Double
}
