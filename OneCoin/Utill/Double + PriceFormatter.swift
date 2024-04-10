//
//  Double + PriceFormatter.swift
//  OneCoin
//
//  Created by 박다혜 on 4/10/24.
//

import Foundation

extension Double {
    func formatPrice() -> String {
        if "\(Int(trunc(self)))".count > 3 {
            let num = Int(trunc(self))
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            return numberFormatter.string(from: NSNumber(value: num)) ?? "\(num)"
        } else if self < 0 {
            return formatComma()
        } else {
            return String(format: "%.1d", formatComma())
        }
    }

    func formatComma() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
