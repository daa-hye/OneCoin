//
//  UpbitAPIManager.swift
//  OneCoin
//
//  Created by 박다혜 on 4/9/24.
//

import Foundation

final class UpbitAPIManager: NSObject {

    static let shared = UpbitAPIManager()

    private override init() {
        super.init()
    }

    func fetchAllMarket() async throws -> [Market] {
        guard let url = URL(string: "https://api.upbit.com/v1/market/all") else { throw APIError.invalidURL }

        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }

        guard let decodedData = try? JSONDecoder().decode([Market].self, from: data) else {
            throw APIError.decodeFail
        }

        return decodedData.filter { market in
            market.market.prefix(3) == "KRW"
        }
    }

    func fetchMinuteCandle(_ market: String) async throws -> [Candle] {
        guard let url = URL(string: "https://api.upbit.com/v1/candles/minutes/10?market=\(market)&count=60") else { throw APIError.invalidURL }

        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }

        guard let decodedData = try? JSONDecoder().decode([Candle].self, from: data) else {
            throw APIError.decodeFail
        }

        return decodedData
    }

}

extension UpbitAPIManager {

    enum APIError: Error {
        case invalidURL
        case invalidResponse
        case decodeFail
    }

}
