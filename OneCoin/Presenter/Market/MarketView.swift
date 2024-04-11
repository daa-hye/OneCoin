//
//  MarketView.swift
//  OneCoin
//
//  Created by 박다혜 on 4/9/24.
//

import SwiftUI

struct MarketView: View {
    @StateObject private var viewModel = MarketViewModel()

    @State private var searchQueryString = ""

    var body: some View {
        let markets: [MarketTicker] = {
            if searchQueryString.isEmpty {
                return viewModel.marketTickers
            } else {
                return viewModel.marketTickers.filter {
                    $0.koreanName.contains(searchQueryString) ||
                    $0.englishName.localizedStandardContains(searchQueryString) ||
                    $0.market.localizedStandardContains(searchQueryString)
                }
            }
        }()

        NavigationStack {
            if !searchQueryString.isEmpty && markets.isEmpty {
                Spacer()
                Text("검색된 코인이 없습니다")
            }
            Section {
                List(markets, id: \.id) { market in
                        ZStack(alignment: .leading) {
                            MarketRow(market: market, like: MarketData.isLiked(market.market))
                            NavigationLink {
                                MarketDetailView(viewModel: MarketDetailViewModel(market: market))
                            } label: {
                                EmptyView()
                            }
                            .opacity(0.0)
                        }
                }
            } header: {

            }
            .navigationTitle("거래소")
            .navigationBarTitleDisplayMode(.inline)
        }
        .listStyle(.plain)
        .environment(\.defaultMinListRowHeight, 50)
        .searchable(text: $searchQueryString, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "코인명/심볼 검색")
        .task {
            await viewModel.fetchAllMarket()
        }
    }
}

#Preview {
    MarketView()
}
