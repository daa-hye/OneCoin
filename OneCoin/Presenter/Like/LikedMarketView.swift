//
//  LikedMarketView.swift
//  OneCoin
//
//  Created by 박다혜 on 4/12/24.
//

import SwiftUI
import Charts

struct LikedMarketView: View {

    let candleChart: CandleChart

    var body: some View {
        Chart {
            ForEach(candleChart.candles, id: \.market) {
                LineMark(
                    x: .value("시간", $0.candleDatetime.toDate(), unit: .minute),
                    y: .value("가격", $0.tradePrice)
                )
                .lineStyle(StrokeStyle(lineWidth: 2.0, lineCap: .round))
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartYScale(domain: candleChart.minPrice...candleChart.maxPrice)
    }
}
