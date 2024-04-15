//
//  LikeView.swift
//  OneCoin
//
//  Created by 박다혜 on 4/12/24.
//

import SwiftUI

struct LikeView: View {

    @StateObject var viewModel = LikeViewModel()
    @FetchRequest(entity: Coin.entity(), sortDescriptors: [])
    private var likedCoins: FetchedResults<Coin>

    var body: some View {
        let list = viewModel.list
        NavigationStack {
            ScrollView {
                Spacer()
                LazyVStack(spacing: 20) {
                    ForEach(list, id: \.self) { item in
                        NavigationLink {
                            MarketDetailView(viewModel: MarketDetailViewModel(market: Market(market: item.market, koreanName: item.name, englishName: item.englishName)))
                        } label: {
                            LikedMarketView(candleChart: item)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .task {
                for coin in likedCoins {
                    await viewModel.fetchMinuteCandle(coin)
                }
            }
            .navigationTitle("관심코인")
        }
    }
}

#Preview {
    LikeView()
}
