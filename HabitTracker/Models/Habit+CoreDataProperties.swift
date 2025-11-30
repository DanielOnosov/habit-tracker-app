//
//  Habit+CoreDataProperties.swift
//  HabitTracker
//
//  Created by Danylo Onosov on 27.11.2025.
//
//

public import Foundation
public import CoreData


public typealias HabitCoreDataPropertiesSet = NSSet

extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var color: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var reminderTime: Date?
    @NSManaged public var schedule: NSObject?
    @NSManaged public var title: String?
    @NSManaged public var completions: NSSet?

}

// MARK: Generated accessors for completions
extension Habit {

    @objc(addCompletionsObject:)
    @NSManaged public func addToCompletions(_ value: HabitCompletion)

    @objc(removeCompletionsObject:)
    @NSManaged public func removeFromCompletions(_ value: HabitCompletion)

    @objc(addCompletions:)
    @NSManaged public func addToCompletions(_ values: NSSet)

    @objc(removeCompletions:)
    @NSManaged public func removeFromCompletions(_ values: NSSet)

}

extension Habit : Identifiable {

}
