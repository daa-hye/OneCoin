//
//  Date + TimeZone.swift
//  OneCoin
//
//  Created by 박다혜 on 4/18/24.
//

import Foundation

extension Date {

    func current() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")

        return dateFormatter.string(from: self)
    }

}
