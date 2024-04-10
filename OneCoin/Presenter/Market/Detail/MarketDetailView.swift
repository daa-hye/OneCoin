//
//  MarketDetailView.swift
//  OneCoin
//
//  Created by 박다혜 on 4/9/24.
//

import SwiftUI
import Charts

struct MarketDetailView: View {

    @StateObject var viewModel: MarketDetailViewModel


    var body: some View {
        let candles = viewModel.candles
        let market = viewModel.market

        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(market.koreanName)
                            .font(.title2)
                            .bold()
                        Text(market.code)
                            .font(.body)
                            .foregroundStyle(.gray)
                    }
                    Text(market.tradePrice.formatPrice() + "원")
                        .font(.title)
                        .bold()
                    HStack {
                        Text("어제보다")
                            .font(.callout)
                            .foregroundStyle(.gray)
                        Text(market.changePrice.formatPrice() + "원")
                            .font(.callout)
                            .foregroundStyle(market.change.setColor())
                        Text(String(format: "(%.2f)", market.changeRate * 100)+"%")
                            .font(.callout)
                            .foregroundStyle(market.change.setColor())
                    }
                }
            }
            .padding()
            Chart {
                ForEach(candles, id: \.market) {
                    LineMark(
                        x: .value("시간", $0.candleDatetime.toDate(), unit: .minute),
                        y: .value("가격", $0.tradePrice)
                    )
                    .lineStyle(StrokeStyle(lineWidth: 2.0, lineCap: .round))
                }
                PointMark(
                    x: .value("최고", viewModel.maxItem.candleDatetime.toDate()),
                    y: .value("최고", viewModel.maxItem.highPrice)
                )
                .annotation(position: .top, alignment: .leading) {
                    Text("최고 "+viewModel.maxItem.highPrice.formatPrice()+"원")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                .opacity(0.5)
                PointMark(
                    x: .value("최저", viewModel.minItem.candleDatetime.toDate()),
                    y: .value("최저", viewModel.minItem.lowPrice)
                )
                .annotation(position: .bottom, alignment: .leading) {
                    Text("최저 "+viewModel.minItem.lowPrice.formatPrice()+"원")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                .opacity(0.5)
                RuleMark(
                    y: .value("시작가", viewModel.startPrice)
                )
                .lineStyle(StrokeStyle(lineWidth: 1.0, lineCap: .butt, dash: [5,5], dashPhase: 0))
                .foregroundStyle(.gray)
            }
            .padding(20)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .chartYScale(domain: viewModel.minItem.lowPrice...viewModel.maxItem.highPrice)
            Spacer(minLength: 50.0)
        }
        .navigationTitle(viewModel.market.koreanName)
        .task {
            await viewModel.fetchMinuteCandlde()
            UpbitWebSocketManager.shared.closeWebSocket()
        }
    }
}
