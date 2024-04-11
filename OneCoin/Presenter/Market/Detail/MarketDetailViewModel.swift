//
//  MarketDetailViewModel.swift
//  OneCoin
//
//  Created by 박다혜 on 4/9/24.
//

import Foundation
import Combine

final class MarketDetailViewModel: ObservableObject {
    
    @Published var marketTicker: MarketTicker
    @Published var candles: [Candle] = []

    private var cancellabel = Set<AnyCancellable>()

    var minItem = Candle(market: "", candleDatetime: "", openingPrice: 0.0, highPrice: 0.0, lowPrice: 0.0, tradePrice: 0.0)
    var maxItem = Candle(market: "", candleDatetime: "", openingPrice: 0.0, highPrice: 0.0, lowPrice: 0.0, tradePrice: 0.0)
    var startPrice = 0.0

    init(market: MarketTicker) {
        self.marketTicker = market
    }

    func fetchMinuteCandlde() async {
        do {
            let candleList = try await UpbitAPIManager.shared.fetchMinuteCandle(marketTicker.market)
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

    func fetchTicker() {
        do {
            try UpbitWebSocketManager.shared.openWebSocket { [weak self] in
                guard let self else { return }
                let market = Market(market: marketTicker.market, koreanName: marketTicker.koreanName, englishName: marketTicker.englishName)

                UpbitWebSocketManager.shared.receive()

                UpbitWebSocketManager.shared.connectTicker(market: market)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] ticker in
                        guard let self else { return }
                        self.marketTicker = ticker
                    }
                    .store(in: &cancellabel)

                UpbitWebSocketManager.shared.send(type: "ticker", list: [market])
            }
        } catch {
            print("소켓 연결 에러")
        }
    }

}
