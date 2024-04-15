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
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return Date()
        }
    }

    func isToday() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")

        if let date = dateFormatter.date(from: self) {
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
            return calendar.isDateInToday(date)
        } else {
            return false
        }
    }
}
