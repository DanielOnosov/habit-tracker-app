//
//  PersistenceTests.swift
//  HabitTrackerTests
//
//  Created by Олена Кошель on 16.12.2025.
//

import XCTest
import CoreData
@testable import HabitTracker

final class PersistenceTests: XCTestCase {
    
    var testStack: TestCoreDataStack!
    
    override func setUp() {
        super.setUp()
        testStack = TestCoreDataStack()
    }
    
    override func tearDown() {
        testStack = nil
        super.tearDown()
    }
    
    func testStackInitialization() {
        XCTAssertNotNil(testStack.persistentContainer)
        XCTAssertEqual(testStack.persistentContainer.persistentStoreDescriptions.first?.type, NSInMemoryStoreType)
    }
    
    func testContextSave() {
        let context = testStack.context
        let habit = Habit(context: context)
        habit.id = UUID()
        habit.title = "Test"
        habit.createdAt = Date()
        
        XCTAssertTrue(context.hasChanges)
        
        do {
            try context.save()
            XCTAssertFalse(context.hasChanges)
        } catch {
            XCTFail("Failed to save context: \(error)")
        }
    }
}
