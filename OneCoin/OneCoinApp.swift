//
//  OneCoinApp.swift
//  OneCoin
//
//  Created by 박다혜 on 4/9/24.
//

import SwiftUI

@main
struct OneCoinApp: App {
    @StateObject private var coreDataStack = CoreDataStack.shared

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext,
                              coreDataStack.persistentContainer.viewContext)
        }
    }
}
