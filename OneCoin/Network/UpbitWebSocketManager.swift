//
//  UpbitWebSocketManager.swift
//  OneCoin
//
//  Created by 박다혜 on 4/9/24.
//

import Foundation
import Combine

final class UpbitWebSocketManager: NSObject {

    static let shared = UpbitWebSocketManager()

    private override init() {
        super.init()
    }

    private var timer: Timer?
    private var webSocket: URLSessionWebSocketTask?
    private var isOpen = false

    var tickerSubjects: [String: PassthroughSubject<Ticker,Never>] = [:]
    var orderbookSubject = PassthroughSubject<Orderbook,Never>()

    var actionWhenSocketOpened: (() -> Void)?

    private var cancellable = Set<AnyCancellable>()

    func openWebSocket(completion: (() -> Void)? = nil) throws {
        guard let url = URL(string: "wss://api.upbit.com/websocket/v1") else { throw WebSocketError.invalidURL }
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)

        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()
        actionWhenSocketOpened = completion

        ping()
    }

    func closeWebSocket() {
        webSocket?.cancel(with: .goingAway, reason: nil)
        webSocket = nil

        timer?.invalidate()
        timer = nil

        isOpen = false
    }

    func send(type: String, list: [String]) {
        let string = """
        [{"ticket":"com.dahye.CoinProject"},{"type":"\(type)","codes":\(list.map{"\($0)"})}]
        """
        webSocket?.send(.string(string)) { _ in }
    }

    func connectTicker(market: Market) -> AnyPublisher<MarketTicker, Never> {

        if tickerSubjects[market.market] == nil {
            tickerSubjects[market.market] = .init()
        }

        let subject = tickerSubjects[market.market]!

        return subject.map { self.combine(market: market, ticker: $0) }.eraseToAnyPublisher()
    }

    func connectOrderbook() -> AnyPublisher<OrderBookChart, Never> {
        return orderbookSubject.map{ self.convert(orderbook:$0) }.eraseToAnyPublisher()
    }

    func receive(item: socketReceive) {
        if isOpen {
            webSocket?.receive(completionHandler: { [weak self] result in
                switch result {
                case .success(let success):
                    switch success {
                    case .data(let data):
                        switch item {
                        case .ticker:
                            if let decodedData = try? JSONDecoder().decode(Ticker.self, from: data) {
                                print("receive \(decodedData)")
                                if let subject = self?.tickerSubjects[decodedData.code] {
                                    subject.send(decodedData)
                                }
                            }
                        case .orderbook:
                            if let decodedData = try? JSONDecoder().decode(Orderbook.self, from: data) {
                                print("receive \(decodedData)")
                                self?.orderbookSubject.send(decodedData)
                            }
                        }
                    case .string(let string):
                        print(string)
                    @unknown default:
                        print("unknown error")
                    }
                case .failure(let failure):
                    print("receive failure \(failure.localizedDescription)")
                    self?.closeWebSocket()
                }
                self?.receive(item: item)
            })
        }
    }

    private func ping() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] _ in
            self?.webSocket?.sendPing(pongReceiveHandler: { error in
                if let error {
                    print("ping pong error : \(error)")
                } else {
                    print("ping")
                }
            })
        })
    }

}

extension UpbitWebSocketManager: URLSessionWebSocketDelegate {

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("--WebSocket Open--")
        isOpen = true
        actionWhenSocketOpened?()
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        isOpen = false
        print("--WebSocket Close--")
    }

}

extension UpbitWebSocketManager {

    enum WebSocketError: Error {
        case invalidURL
        case sendFail
    }

    private func combine(market: Market, ticker: Ticker) -> MarketTicker {
        MarketTicker(market: market.market, koreanName: market.koreanName, englishName: market.englishName, tradePrice: ticker.tradePrice, change: ticker.change, changePrice: ticker.changePrice, changeRate: ticker.changeRate, accTradePrice: ticker.accTradePrice, image: URL(string: "https://static.upbit.com/logos/\(market.market.split(separator: "-").map({String($0)})[1]).png")!, code: market.market.split(separator: "-").map({String($0)})[1])
    }

    private func convert(orderbook: Orderbook) -> OrderBookChart {
        OrderBookChart(code: orderbook.code, timestamp: orderbook.timestamp, totalAskSize: orderbook.totalAskSize, totalBidSize: orderbook.totalBidSize, askOrderBook: orderbook.orderbookUnits.map{OrderBookItem(price: $0.askPrice, size: $0.askSize)}.sorted(by: {$0.price > $1.price}), bidOrderBook: orderbook.orderbookUnits.map{OrderBookItem(price: $0.bidPrice, size: $0.bidSize)}.sorted(by: {$0.price > $1.price}))
    }

}

enum socketReceive {
    case ticker
    case orderbook
}
