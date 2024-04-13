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
                            HStack {
                                ZStack(alignment: .trailing) {
                                    let graphSize = (CGFloat(item.size) / CGFloat(largestBidSize) * graphWidth) * 0.9
                                    RoundedRectangle(cornerRadius: 2.0, style: .continuous)
                                        .foregroundStyle(.blue.opacity(0.1))
                                        .frame(maxWidth: graphSize, alignment: .trailing)
                                    Text(item.size.formatted())
                                        .frame(width: graphWidth, alignment: .trailing)
                                        .font(.footnote)
                                        .foregroundStyle(.blue)
                                }
                                .background(.white.opacity(0.1))
                                Text(item.price.formatted())
                                    .frame(width: graphWidth * 0.6)
                                    .font(.subheadline)
                                Spacer(minLength: graphWidth * 0.8)
                            }
                            .frame(height: 30)
                        }
                        ForEach(orderbook.askOrderBook, id: \.id) { item in
                            HStack {
                                Spacer(minLength: graphWidth * 0.8)
                                Text(item.price.formatted())
                                    .frame(width: graphWidth * 0.6)
                                    .font(.subheadline)
                                ZStack(alignment: .leading) {
                                    let graphSize = (CGFloat(item.size) / CGFloat(largestAskSize) * graphWidth) * 0.9
                                    RoundedRectangle(cornerRadius: 2.0, style: .continuous)
                                        .foregroundStyle(.red.opacity(0.1))
                                        .frame(maxWidth: graphSize, alignment: .leading)
                                    Text(item.size.formatted())
                                        .frame(width: graphWidth, alignment: .leading)
                                        .font(.footnote)
                                        .foregroundStyle(.red)
                                }
                                .background(.white.opacity(0.1))
                            }
                            .frame(height: 30)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
