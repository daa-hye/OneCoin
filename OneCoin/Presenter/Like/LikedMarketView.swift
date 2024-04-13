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
        ZStack {
            RoundedRectangle(cornerRadius: 15, style: .circular)
                .fill(.white)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 1, y: 1)
                .frame(height: 150)
            VStack(alignment: .leading) {
                Text(candleChart.name)
                    .font(.body)
                    .bold()
                    .padding(5)
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
            .padding(5)
        }
        .padding(.horizontal, 15)
    }
}
