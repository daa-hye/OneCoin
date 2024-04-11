//
//  MarketData.swift
//  OneCoin
//
//  Created by 박다혜 on 4/11/24.
//

import Foundation

enum MarketData {

    static func toggle(_ code: String) {
        var list = UserDefaults.standard.array(forKey: "like") as? [String] ?? []
        if let index = list.firstIndex(of: code) {
            list.remove(at: index)
        } else {
            list.append(code)
        }
        UserDefaults.standard.set(list, forKey: "like")
    }

    static func isLiked(_ code: String) -> Bool {
        let list = UserDefaults.standard.array(forKey: "like") as? [String] ?? []
        if let _ = list.firstIndex(of: code) { return true }
        return false
    }

}
