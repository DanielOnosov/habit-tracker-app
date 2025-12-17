//
//  CreateEditViewModelTests.swift
//  HabitTrackerTests
//
//  Created by Олена Кошель on 16.12.2025.
//


import XCTest
import CoreData
@testable import HabitTracker

final class CreateEditViewModelTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        context = TestCoreDataStack.shared.context
    }
    
    override func tearDown() {
        
        let request: NSFetchRequest<NSFetchRequestResult> = Habit.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        deleteRequest.resultType = .resultTypeObjectIDs
        
        
        if let habits = try? context.fetch(Habit.fetchRequest()) {
            for habit in habits {
                context.delete(habit)
            }
        }
        try? context.save()
        super.tearDown()
    }
    
    private func deleteAllHabits() {
        let request: NSFetchRequest<NSFetchRequestResult> = Habit.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        try? context.execute(deleteRequest)
        try? context.save()
    }
    
    
    func testCreateHabit() {
        let viewModel = CreateHabitViewModel(context: context)
        let payload = HabitPayload(title: "Yoga", reminderTime: Date(), color: "#FF00FF", schedule: [1, 3])
        
        viewModel.add(payload)
        
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        let habits = try? context.fetch(request)
        
        XCTAssertEqual(habits?.count, 1)
        let habit = habits?.first
        XCTAssertEqual(habit?.title, "Yoga")
        XCTAssertEqual(habit?.color, "#FF00FF")
        XCTAssertEqual(habit?.scheduleInts.sorted(), [1, 3])
        XCTAssertNotNil(habit?.id)
        XCTAssertNotNil(habit?.createdAt)
    }
    
    func testCreateHabitWithoutReminder() {
        let viewModel = CreateHabitViewModel(context: context)
        let payload = HabitPayload(title: "Read", reminderTime: nil, color: "#0000FF", schedule: [])
        
        viewModel.add(payload)
        
        let habits = try? context.fetch(Habit.fetchRequest())
        XCTAssertEqual(habits?.count, 1)
        XCTAssertNil(habits?.first?.reminderTime)
    }
    
    
    func testEditHabitSuccess() {
        
        let habit = Habit(context: context)
        habit.id = UUID()
        habit.title = "Old Title"
        habit.color = "Old Color"
        try? context.save()
      
        let viewModel = EditHabitViewModel(context: context, habitID: habit.id!)
        let newPayload = EditHabitPayload(title: "New Title", reminderTime: nil, color: "New Color", schedule: [0])
        
        viewModel.edit(id: habit.id!, newPayload)
        
       
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        let fetched = try? context.fetch(request).first
        
        XCTAssertEqual(fetched?.title, "New Title")
        XCTAssertEqual(fetched?.color, "New Color")
        XCTAssertEqual(fetched?.scheduleInts, [0])
    }
    
    func testEditHabitPartialUpdate() {
       
        let habit = Habit(context: context)
        habit.id = UUID()
        habit.title = "Original"
        habit.color = "Red"
        try? context.save()
        
        
        let viewModel = EditHabitViewModel(context: context, habitID: habit.id!)
        let partialPayload = EditHabitPayload(title: "Updated", reminderTime: nil, color: nil, schedule: nil)
        
        viewModel.edit(id: habit.id!, partialPayload)
        
        
        XCTAssertEqual(habit.title, "Updated")
        XCTAssertEqual(habit.color, "Red") 
    }
}
