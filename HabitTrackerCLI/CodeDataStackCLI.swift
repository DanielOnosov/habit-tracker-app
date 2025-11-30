//
//  CodeDataStackCLI.swift
//  HabitTracker
//
//  Created by Danylo Onosov on 22.11.2025.
//

import Foundation
import CoreData

final class CoreDataStackCLI {

    static let shared = CoreDataStackCLI()

    let container: NSPersistentContainer

    private init() {
        let modelURL = Bundle.main.url(forResource: "HabitModel", withExtension: "momd")!

        let model = NSManagedObjectModel(contentsOf: modelURL)!

        container = NSPersistentContainer(name: "Habit", managedObjectModel: model)

        let storeURL = URL(fileURLWithPath: "/tmp/habit_test.sqlite")

        container.persistentStoreDescriptions = [
            NSPersistentStoreDescription(url: storeURL)
        ]

        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("Failed to load Core Data store: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        container.viewContext
    }
}
