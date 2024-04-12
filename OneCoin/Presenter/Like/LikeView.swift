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

        VStack {
            ForEach(list, id: \.self) {
                LikedMarketView(candleChart: $0)
            }
        }
        .task {
            for coin in likedCoins {
                await viewModel.fetchMinuteCandle(coin)
            }
        }
    }
}

#Preview {
    LikeView()
}
