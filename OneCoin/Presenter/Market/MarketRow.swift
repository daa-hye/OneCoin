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
    @State var like: Bool

    var body: some View {
        HStack {
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
            .frame(minWidth: 50)
            Spacer()
            Image(systemName: "heart.fill")
                .resizable()
                .frame(width: 23, height: 23)
                .foregroundStyle(like ? Color.pink : Color("Unlike"))
                .onTapGesture {
                    MarketData.toggle(market.market)
                    like.toggle()
                }
        }
        .padding(5)
    }
}
