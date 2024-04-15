//
//  LikeViewModel.swift
//  OneCoin
//
//  Created by 박다혜 on 4/12/24.
//

import Foundation

final class LikeViewModel: ObservableObject {

    @Published var list: [CandleChart] = []

    func fetchMinuteCandle(_ coin: Coin) async {
        do {
            let candleList = try await UpbitAPIManager.shared.fetchMinuteCandle(coin.code!)
            let chart = CandleChart(
                market: coin.code!,
                name: coin.name!,
                englishName: coin.englishName!,
                candles: candleList,
                minPrice: candleList.min(by: {$0.lowPrice < $1.lowPrice})!.lowPrice,
                maxPrice: candleList.max(by: {$0.highPrice < $1.highPrice})!.highPrice
            )
            await MainActor.run {
                if let index = list.firstIndex(where: { $0.name == coin.name }) {
                    list[index] = chart
                } else {
                    list.append(chart)
                }
            }
        } catch {
            print("캔들 가져오기 에러")
        }
    }

}
