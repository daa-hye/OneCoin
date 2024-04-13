//
//  MarketViewModel.swift
//  OneCoin
//
//  Created by 박다혜 on 4/9/24.
//

import Foundation
import Combine

final class MarketViewModel: ObservableObject {

    @Published var markets: [Market] = []
    @Published var marketTickers: [MarketTicker] = []

    private var cancellabel = Set<AnyCancellable>()

    func fetchAllMarket() async {
        cancellabel = .init()
        do {
            let allMarket = try await UpbitAPIManager.shared.fetchAllMarket()
            await MainActor.run {
                markets = allMarket
                Task {
                    await fetchAllTicker()
                }
            }
        } catch {
            print("마켓 리스트 가져오기 에러")
        }
    }

    func fetchAllTicker() async {
        do {
            try UpbitWebSocketManager.shared.openWebSocket { [weak self] in
                guard let self else { return }

                UpbitWebSocketManager.shared.receive(item: .ticker)

                self.markets.publisher
                    .flatMap { market -> AnyPublisher<MarketTicker, Never> in
                        return UpbitWebSocketManager.shared.connectTicker(market: market)
                    }
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] ticker in
                        guard let self else { return }

                        if let index = self.marketTickers.firstIndex(where: { $0.market == ticker.market }) {
                            self.marketTickers[index] = ticker
                        } else {
                            self.marketTickers.append(ticker)
                        }
                    }
                    .store(in: &cancellabel)


                UpbitWebSocketManager.shared.send(type: "ticker", list: self.markets.map({$0.market}))
            }
        } catch {
            print("소켓 연결 에러")
        }
    }
}
