//
//  HabitModelTests.swift
//  HabitTrackerTests
//
//  Created by Олена Кошель on 16.12.2025.
//

import XCTest
import CoreData
@testable import HabitTracker

final class HabitModelTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        context = TestCoreDataStack.shared.context
    }

    func testHabitAttributes() {
        let habit = Habit(context: context)
        habit.id = UUID()
        habit.title = "Run"
        habit.color = "#FFFFFF"
        
        XCTAssertNotNil(habit.id)
        XCTAssertEqual(habit.title, "Run")
        XCTAssertEqual(habit.color, "#FFFFFF")
    }
    
    func testScheduleIntsComputedProperty() {
        let habit = Habit(context: context)
        
      
        XCTAssertTrue(habit.scheduleInts.isEmpty)
        
        
        let days = [1, 2, 3]
        habit.setSchedule(days)
        
        let retrieved = habit.scheduleInts
        XCTAssertEqual(retrieved.count, 3)
        XCTAssertTrue(retrieved.contains(1))
        XCTAssertTrue(retrieved.contains(2))
        XCTAssertTrue(retrieved.contains(3))
        
        
        XCTAssertTrue(habit.schedule is NSArray)
    }
    
    func testScheduleIntsEdgeCases() {
        let habit = Habit(context: context)
        
      
        XCTAssertTrue(habit.scheduleInts.isEmpty)
        
        habit.schedule = NSArray()
        XCTAssertTrue(habit.scheduleInts.isEmpty)
        
        let mixedArray: NSArray = [1, "String", 2.5, 3]
        habit.schedule = mixedArray
        
        let ints = habit.scheduleInts
    
        
        XCTAssertTrue(ints.contains(1))
        XCTAssertTrue(ints.contains(3))
        XCTAssertTrue(ints.contains(2))
    }
    
    func testSetScheduleUpdates() {
        let habit = Habit(context: context)
        
        habit.setSchedule([1, 2])
        XCTAssertEqual(habit.scheduleInts.count, 2)
        
        habit.setSchedule([3, 4, 5])
        let newSchedule = habit.scheduleInts
        XCTAssertEqual(newSchedule.count, 3)
        XCTAssertTrue(newSchedule.contains(3))
        XCTAssertFalse(newSchedule.contains(1))
        
        habit.setSchedule([])
        XCTAssertTrue(habit.scheduleInts.isEmpty)
    }
}
