//
//  MainTabView.swift
//  OneCoin
//
//  Created by 박다혜 on 4/9/24.
//

import SwiftUI

struct MainTabView: View {

    @State private var selectedTab = "market"

    var body: some View {
        TabView(selection: $selectedTab) {
            Text("1")
            .tabItem { Image(systemName: "heart.fill") }
            .tag("like")
            MarketView()
                .tabItem { Image(systemName: "chart.line.uptrend.xyaxis") }
                .tag("market")
            Text("3")
                .tabItem { Image(systemName: "ellipsis") }
                .tag("setting")
        }.tint(.red)
    }
}

#Preview {
    MainTabView()
}
