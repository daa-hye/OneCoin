//
//  MarketDetailViewModel.swift
//  OneCoin
//
//  Created by 박다혜 on 4/9/24.
//

import Foundation
import Combine

final class MarketDetailViewModel: ObservableObject {
    
    let market: Market

    @Published var marketTicker = MarketTicker(market: "", koreanName: "", englishName: "", tradePrice: 0, change: "", changePrice: 0, changeRate: 0, accTradePrice: 0, accTradeVolume: 0, highest52WeekPrice: 0, lowest52WeekPrice: 0, highest52WeekDate: "", lowest52WeekDate: "", image: nil, code: "")
    @Published var candles: [Candle] = []
    @Published var orderbook: OrderBookChart = OrderBookChart(code: "", timestamp: 0, totalAskSize: 0.0, totalBidSize: 0.0, askOrderBook: [], bidOrderBook: [])
    
    private var cancellable = Set<AnyCancellable>()
    
    var minItem = Candle(market: "", candleDatetime: "", openingPrice: 0.0, highPrice: 0.0, lowPrice: 0.0, tradePrice: 0.0)
    var maxItem = Candle(market: "", candleDatetime: "", openingPrice: 0.0, highPrice: 0.0, lowPrice: 0.0, tradePrice: 0.0)
    var startPrice = 0.0
    var count = 0
    
    init(market: Market) {
        self.market = market
    }
    
    func fetchTicker() {
        do {
            try UpbitWebSocketManager.shared.openWebSocket { [weak self] in
                guard let self else { return }

                UpbitWebSocketManager.shared.receive(item: .ticker)
                
                UpbitWebSocketManager.shared.connectTicker(market: market)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] ticker in
                        guard let self else { return }
                        self.marketTicker = ticker
                    }
                    .store(in: &cancellable)
                
                UpbitWebSocketManager.shared.send(type: "ticker", list: [market.market])
            }
        } catch {
            print("소켓 연결 에러")
        }
    }
    
    func fetchMinuteCandlde() async {
        do {
            let candleList = try await UpbitAPIManager.shared.fetchMinuteCandle(market.market)
            await MainActor.run {
                candles = candleList.filter{$0.candleDatetime.isToday()}
                count = candles.count
                minItem = candles.min(by: {$0.lowPrice < $1.lowPrice})!
                maxItem = candles.max(by: {$0.highPrice < $1.highPrice})!
                startPrice = candles[0].openingPrice
                $marketTicker
                    .sink { [weak self] marketTicker in
                        guard let self else { return }
                        if count > 0 {
                            let candle = Candle(market: marketTicker.market, candleDatetime: Date().current(), openingPrice: marketTicker.tradePrice, highPrice: marketTicker.tradePrice, lowPrice: marketTicker.tradePrice, tradePrice: marketTicker.tradePrice)
                            if candles.count == count {
                                candles.append(candle)
                            } else {
                                candles[count] = candle
                            }
                        }
                    }
                    .store(in: &cancellable)
            }
        } catch {
            print("캔들 가져오기 에러")
        }
    }
    
    func fetchOrderbook() {
        do {
            try UpbitWebSocketManager.shared.openWebSocket { [weak self] in
                guard let self else { return }
                
                UpbitWebSocketManager.shared.receive(item: .orderbook)
                
                UpbitWebSocketManager.shared.connectOrderbook()
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] orderbook in
                        guard let self else { return }
                        self.orderbook = orderbook
                    }
                    .store(in: &cancellable)
                
                UpbitWebSocketManager.shared.send(type: "orderbook", list: [market.market])
            }
        } catch {
            
        }
    }
    
    func largestAskSize() -> Double {
        return orderbook.askOrderBook.sorted(by: {$0.size > $1.size}).first?.size ?? 0.0
    }
    
    func largestBidSize() -> Double {
        return orderbook.bidOrderBook.sorted(by: {$0.size > $1.size}).first?.size ?? 0.0
    }
    
}
