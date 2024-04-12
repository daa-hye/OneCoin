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
            Rectangle()
                .fill(.white)
                .clipShape(RoundedRectangle(cornerRadius: 15), style: FillStyle())
                .shadow(color: Color.black.opacity(0.3), radius: 2, x: 5, y: 5)
                .frame(height: 150)
                .padding()
            VStack(alignment: .leading) {
                Spacer()
                Text(candleChart.name)
                    .padding()
                    .font(.title2)
                    .bold()
                Chart {
                    ForEach(candleChart.candles, id: \.market) {
                        LineMark(
                            x: .value("시간", $0.candleDatetime.toDate(), unit: .minute),
                            y: .value("가격", $0.tradePrice)
                        )
                        .lineStyle(StrokeStyle(lineWidth: 2.0, lineCap: .round))
                    }
                }
                .padding()
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .chartYScale(domain: candleChart.minPrice...candleChart.maxPrice)
            }
            .padding(10)
        }
    }
}
