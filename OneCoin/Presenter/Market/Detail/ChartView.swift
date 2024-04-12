//
//  ChartView.swift
//  OneCoin
//
//  Created by 박다혜 on 4/12/24.
//

import SwiftUI
import Charts

struct ChartView: View {

    let candles: [Candle]
    let maxItem: Candle
    let minItem: Candle
    let startPrice: Double

    var body: some View {
        Chart {
            ForEach(candles, id: \.market) {
                LineMark(
                    x: .value("시간", $0.candleDatetime.toDate(), unit: .minute),
                    y: .value("가격", $0.tradePrice)
                )
                .lineStyle(StrokeStyle(lineWidth: 2.0, lineCap: .round))
            }
            PointMark(
                x: .value("최고", maxItem.candleDatetime.toDate()),
                y: .value("최고", maxItem.highPrice)
            )
            .annotation(position: .top, alignment: .leading) {
                Text("최고 "+maxItem.highPrice.formatPrice()+"원")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
            .opacity(0.5)
            PointMark(
                x: .value("최저", minItem.candleDatetime.toDate()),
                y: .value("최저", minItem.lowPrice)
            )
            .annotation(position: .bottom, alignment: .leading) {
                Text("최저 "+minItem.lowPrice.formatPrice()+"원")
                    .font(.caption)
                    .foregroundStyle(.red)
            }
            .opacity(0.5)
            RuleMark(
                y: .value("시작가", startPrice)
            )
            .lineStyle(StrokeStyle(lineWidth: 1.0, lineCap: .butt, dash: [5,5], dashPhase: 0))
            .foregroundStyle(.gray)
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartYScale(domain: minItem.lowPrice...maxItem.highPrice)
    }
}
