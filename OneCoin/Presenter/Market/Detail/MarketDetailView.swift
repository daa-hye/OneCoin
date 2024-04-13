//
//  MarketDetailView.swift
//  OneCoin
//
//  Created by 박다혜 on 4/9/24.
//

import SwiftUI

struct MarketDetailView: View {

    @StateObject var viewModel: MarketDetailViewModel
    @State var selectedTab: Tab = .chart

    var body: some View {
        let candles = viewModel.candles
        let market = viewModel.marketTicker

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
            HStack {
                Button("차트") {
                    selectedTab = .chart
                }
                .foregroundStyle(selectedTab == .chart ? .red : .gray)
                .buttonStyle(.bordered)
                .tint(selectedTab == .chart ? .gray : .white)
                Button("호가") {
                    selectedTab = .orderbook
                }
                .foregroundStyle(selectedTab == .orderbook ? .red : .gray)
                .buttonStyle(.bordered)
                .tint(selectedTab == .orderbook ? .gray : .white)
            }
            .padding(.leading, 10)
            Divider()
                .padding(.bottom, 30)

            switch selectedTab {
            case .chart:
                ChartView(candles: candles, maxItem: viewModel.maxItem, minItem: viewModel.minItem, startPrice: viewModel.startPrice)
                    .padding(20)
                    .task {
                        await viewModel.fetchMinuteCandlde()
                    }
                Spacer(minLength: 50.0)
            case .orderbook:
                OrderbookView(
                    orderbook: $viewModel.orderbook,
                    largestAskSize: viewModel.largestAskSize(),
                    largestBidSize: viewModel.largestBidSize()
                )
                .task {
                    viewModel.fetchOrderbook()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.fetchTicker()
        }
    }
}

enum Tab {
    case chart
    case orderbook
}
