//
//  OrderbookView.swift
//  OneCoin
//
//  Created by 박다혜 on 4/14/24.
//

import SwiftUI

struct OrderbookView: View {

    @Binding var orderbook: OrderBookChart
    @Binding var marketTicker: MarketTicker
    var largestAskSize: Double
    var largestBidSize: Double

    var body: some View {
        GeometryReader { proxy in
            ScrollViewReader { _ in
                ScrollView {
                    let graphWidth = proxy.size.width * 0.4
                    VStack {
                        ForEach(orderbook.bidOrderBook, id: \.id) { item in
                            Group {
                                Text(item.price.formatted())
                                    .frame(width: proxy.size.width * 0.3, alignment: .center)
                                    .font(.footnote)
                            }
                            .frame(height: 30)
                            .frame(maxWidth:.infinity)
                            .overlay(alignment: .leading) {
                                ZStack(alignment: .trailing) {
                                    let graphSize = (CGFloat(item.size) / CGFloat(largestBidSize) * graphWidth) * 0.7
                                    RoundedRectangle(cornerRadius: 2.0, style: .continuous)
                                        .foregroundStyle(.blue.opacity(0.1))
                                        .frame(maxWidth: graphSize, alignment: .trailing)
                                    Text(item.size.formatted())
                                        .frame(width: graphWidth, alignment: .trailing)
                                        .font(.footnote)
                                        .foregroundStyle(.blue)
                                }
                                .background(.white.opacity(0.1))
                                .frame(width: proxy.size.width * 0.3)
                            }
                        }
                    }
                    .overlay(alignment: .bottomTrailing) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("거래량")
                                    .font(.caption2)
                                Text("거래금")
                                    .font(.caption2)
                                Text("52주 최대")
                                    .font(.caption2)
                                Text("52주 최소")
                                    .font(.caption2)
                            }
                            VStack(alignment: .trailing){
                                Text(marketTicker.accTradeVolume.formatComma())
                                    .font(.caption2)
                                Text((marketTicker.accTradePrice/1000000).formatPrice() + "백만원")
                                    .font(.caption2)
                                Text(marketTicker.highest52WeekPrice.formatPrice())
                                    .font(.caption2)
                                    .foregroundStyle(.red)
                                Text(marketTicker.lowest52WeekPrice.formatPrice())
                                    .font(.caption2)
                                    .foregroundStyle(.blue)
                            }
                        }
                        .padding()
                    }
                    VStack {
                        ForEach(orderbook.askOrderBook, id: \.id) { item in
                            Group {
                                Text(item.price.formatted())
                                    .frame(width: proxy.size.width * 0.3, alignment: .center)
                                    .font(.footnote)
                            }
                            .frame(height: 30)
                            .frame(maxWidth:.infinity)
                            .overlay(alignment: .trailing, content: {
                                ZStack(alignment: .leading) {
                                    let graphSize = (CGFloat(item.size) / CGFloat(largestAskSize) * graphWidth) * 0.7
                                    RoundedRectangle(cornerRadius: 2.0, style: .continuous)
                                        .foregroundStyle(.red.opacity(0.1))
                                        .frame(maxWidth: graphSize, alignment: .leading)
                                    Text(item.size.formatted())
                                        .frame(width: graphWidth, alignment: .leading)
                                        .font(.footnote)
                                        .foregroundStyle(.red)
                                }
                                .background(.white.opacity(0.1))
                                .frame(width: proxy.size.width * 0.3)
                            })
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
