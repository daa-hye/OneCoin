//
//  MarketRow.swift
//  OneCoin
//
//  Created by 박다혜 on 4/9/24.
//

import SwiftUI
import Kingfisher

struct MarketRow: View {
    @State var market: MarketTicker

    var body: some View {
        HStack(spacing: 15) {
            KFImage(market.image)
                .resizable()
                .frame(width: 25, height: 25)
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .bottom) {
                    Text("\(market.koreanName)")
                        .font(.footnote)
                        .fontWeight(.bold)
                    Text("\(market.market)")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }
                HStack {
                    Text(market.tradePrice.formatPrice()+"원")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Text(String(format: "%.2f", market.changeRate * 100)+"%")
                        .font(.caption)
                        .foregroundStyle(market.change.setColor())
                }
            }
        }
    }
}
