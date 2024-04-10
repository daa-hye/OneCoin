//
//  MarketDetailViewModel.swift
//  OneCoin
//
//  Created by 박다혜 on 4/9/24.
//

import Foundation

final class MarketDetailViewModel: ObservableObject {
    
    @Published var market: MarketTicker
    @Published var candles: [Candle] = []

    var minItem = Candle(market: "", candleDatetime: "", openingPrice: 0.0, highPrice: 0.0, lowPrice: 0.0, tradePrice: 0.0)
    var maxItem = Candle(market: "", candleDatetime: "", openingPrice: 0.0, highPrice: 0.0, lowPrice: 0.0, tradePrice: 0.0)
    var startPrice = 0.0

    init(market: MarketTicker) {
        self.market = market
    }

    func fetchMinuteCandlde() async {
        do {
            let candleList = try await UpbitAPIManager.shared.fetchMinuteCandle(market.market)
            await MainActor.run {
                candles = candleList
                minItem = candles.min(by: {$0.lowPrice < $1.lowPrice})!
                maxItem = candles.max(by: {$0.highPrice < $1.highPrice})!
                print(minItem, maxItem)
                startPrice = candles[0].openingPrice
            }
        } catch {
            print("캔들 가져오기 에러")
        }
    }
}
