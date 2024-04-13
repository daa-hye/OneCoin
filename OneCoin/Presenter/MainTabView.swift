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
            LikeView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("관심코인")
                }
            .tag("like")
            MarketView()
                .tabItem { 
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("코인정보")
                }
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
