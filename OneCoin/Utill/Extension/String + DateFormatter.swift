//
//  String + DateFormatter.swift
//  OneCoin
//
//  Created by 박다혜 on 4/9/24.
//

import Foundation

extension String {
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return Date()
        }
    }
}
