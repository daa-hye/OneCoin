//
//  CoreDataStack.swift
//  OneCoin
//
//  Created by 박다혜 on 4/12/24.
//

import Foundation
import CoreData

class CoreDataStack: ObservableObject {

    static let shared = CoreDataStack()

    private init() { }

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "LikedCoinModel")

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()

}

extension CoreDataStack {

    func save() {
        guard persistentContainer.viewContext.hasChanges else { return }

        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save the context:", error.localizedDescription)
        }
    }

    func delete(item: Coin) {
        persistentContainer.viewContext.delete(item)
    }

}
