//
//  MarketDetailView.swift
//  OneCoin
//
//  Created by 박다혜 on 4/9/24.
//

import SwiftUI

struct MarketDetailView: View {

    @StateObject var viewModel: MarketDetailViewModel

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
            ChartView(candles: candles, maxItem: viewModel.maxItem, minItem: viewModel.minItem, startPrice: viewModel.startPrice)
                .padding(20)
            Spacer(minLength: 50.0)
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchMinuteCandlde()
            viewModel.fetchTicker()
        }
    }
}
