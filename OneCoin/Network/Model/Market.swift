//
//  Market.swift
//  OneCoin
//
//  Created by 박다혜 on 4/9/24.
//

import Foundation

struct Market: Codable, Hashable {
    let market: String
    let koreanName: String
    let englishName: String

    enum CodingKeys: String, CodingKey {
        case market
        case koreanName = "korean_name"
        case englishName = "english_name"
    }
}
