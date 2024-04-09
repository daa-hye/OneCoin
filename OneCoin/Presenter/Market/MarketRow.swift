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
                    Text(priceFormatting(market.tradePrice)+"원")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Text(String(format: "%.2f", market.changeRate * 100)+"%")
                        .font(.caption)
                        .foregroundStyle(setColor(market.change))
                }
            }
        }
    }
}

extension MarketRow {
    private func setColor(_ item: String) -> Color {
        switch item {
        case "RISE":
            return  .red
        case "FALL":
            return .blue
        default:
            return .black
        }
    }

    private func priceFormatting(_ price: Double) -> String {
        if "\(Int(trunc(price)))".count > 3 {
            return "\(Int(trunc(price)))"
        } else if price < 0 {
            return "\(price)"
        } else {
            return String(format: "%.1d", "\(price)")
        }
    }

    private func changePriceFormatting(_ price: Double) -> String {
        if "\(Int(trunc(price)))".count > 2 {
            return "\(Int(trunc(price)))"
        } else if price < 0 {
            return "\(price)"
        } else {
            return String(format: "%.1d", "\(price)")
        }
    }

    private func accumulatePriceFormatting(_ price: Double) -> String {
        if "\(Int(trunc(price)))".count > 6 {
            return "\((Int(trunc(price)))/1000000)백만"
        } else {
            return "\(Int(trunc(price)))"
        }
    }
}
