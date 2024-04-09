//
//  MarketDetailView.swift
//  OneCoin
//
//  Created by 박다혜 on 4/9/24.
//

import SwiftUI

struct MarketDetailView: View {

    var market: Market

    var body: some View {
        Text(market.koreanName)
            .navigationTitle(market.koreanName)
    }
}
