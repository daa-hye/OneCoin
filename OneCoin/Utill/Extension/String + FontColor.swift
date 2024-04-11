//
//  String + FontColor.swift
//  OneCoin
//
//  Created by 박다혜 on 4/10/24.
//

import SwiftUI

extension String {
    func setColor() -> Color {
        switch self {
        case "RISE":
            return  .red
        case "FALL":
            return .blue
        default:
            return .black
        }
    }
}
