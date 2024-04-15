//
//  OrderbookView.swift
//  OneCoin
//
//  Created by 박다혜 on 4/14/24.
//

import SwiftUI

struct OrderbookView: View {

    @Binding var orderbook: OrderBookChart
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
                                    .frame(width: proxy.size.width * 0.4, alignment: .center)
                                    .font(.subheadline)
                            }
                            .frame(height: 30)
                            .frame(maxWidth:.infinity)
                            .overlay(alignment: .leading, content: {
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
                            })
                        }
                        ForEach(orderbook.askOrderBook, id: \.id) { item in
                            Group {
                                Text(item.price.formatted())
                                    .frame(width: proxy.size.width * 0.4, alignment: .center)
                                    .font(.subheadline)
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
