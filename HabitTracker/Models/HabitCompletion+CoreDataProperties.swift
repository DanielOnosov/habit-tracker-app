//
//  HabitCompletion+CoreDataProperties.swift
//  HabitTracker
//
//  Created by Danylo Onosov on 27.11.2025.
//
//

public import Foundation
public import CoreData


public typealias HabitCompletionCoreDataPropertiesSet = NSSet

extension HabitCompletion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HabitCompletion> {
        return NSFetchRequest<HabitCompletion>(entityName: "HabitCompletion")
    }

    @NSManaged public var completedAt: Date?
    @NSManaged public var habit: Habit?

}

extension HabitCompletion : Identifiable {

}
