//
//  HabitListViewModelTests.swift
//  HabitTrackerTests
//
//  Created by Олена Кошель on 16.12.2025.
//

import XCTest
import CoreData
@testable import HabitTracker

final class HabitListViewModelTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    var viewModel: HabitListViewModel!
    
    override func setUp() {
        super.setUp()
        context = TestCoreDataStack.shared.context
        viewModel = HabitListViewModel(context: context)
    }
    
    override func tearDown() {
        if let habits = try? context.fetch(Habit.fetchRequest()) {
            for habit in habits {
                context.delete(habit)
            }
        }
        try? context.save()
        super.tearDown()
    }
    
    private func deleteAllHabits() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Habit.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try? context.execute(deleteRequest)
        try? context.save()
    }
    
    func testFilterStability() {
        let h1 = createHabit(title: "A")
        let h2 = createHabit(title: "A")
        h1.createdAt = Date()
        h2.createdAt = Date().addingTimeInterval(10)
        
        viewModel.load(filterType: .alpha)
  
        XCTAssertEqual(viewModel.habits.count, 2)
    }
    
    func testLargeDataSet() {
        for i in 0..<20 {
            _ = createHabit(title: "Habit \(i)")
        }
        viewModel.load(filterType: .newest)
        XCTAssertEqual(viewModel.habits.count, 20)
        XCTAssertGreaterThanOrEqual(viewModel.habits.count, 20)
    }
    
    func testLoadAlphaFilter() {
        createHabit(title: "C Habit")
        createHabit(title: "A Habit")
        createHabit(title: "B Habit")
        
        viewModel.load(filterType: .alpha)
        
        XCTAssertEqual(viewModel.habits.count, 3)
        XCTAssertEqual(viewModel.habits[0].title, "A Habit")
        XCTAssertEqual(viewModel.habits[1].title, "B Habit")
        XCTAssertEqual(viewModel.habits[2].title, "C Habit")
    }
    
    func testLoadNewestFilter() {
        let h1 = createHabit(title: "Old")
        h1.createdAt = Date().addingTimeInterval(-1000)
        let h2 = createHabit(title: "New")
        h2.createdAt = Date()
        try? context.save()
        
        viewModel.load(filterType: .newest)
        
        XCTAssertEqual(viewModel.habits.count, 2)
        XCTAssertEqual(viewModel.habits[0].title, "New")
        XCTAssertEqual(viewModel.habits[1].title, "Old")
    }
    
    func testLoadStreakFilter() {
        
        let h1 = createHabit(title: "Low Streak")
        let h2 = createHabit(title: "High Streak")
        
       
        addCompletion(to: h2, date: Date())
        addCompletion(to: h2, date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
        
      
        addCompletion(to: h1, date: Date())
        
        viewModel.load(filterType: .streak)
        
        XCTAssertEqual(viewModel.habits.count, 2)
        XCTAssertEqual(viewModel.habits[0].title, "High Streak")
        XCTAssertEqual(viewModel.habits[1].title, "Low Streak")
    }
    
    func testLoadEmptyState() {
        viewModel.load(filterType: .newest)
        XCTAssertTrue(viewModel.habits.isEmpty)
        
        viewModel.load(filterType: .alpha)
        XCTAssertTrue(viewModel.habits.isEmpty)
        
        viewModel.load(filterType: .streak)
        XCTAssertTrue(viewModel.habits.isEmpty)
    }

    func testDeleteHabit() {
        let habit = createHabit(title: "To Delete")
        viewModel.load(filterType: .alpha)
        
        XCTAssertEqual(viewModel.habits.count, 1)
        
        viewModel.delete(habit)
        
        XCTAssertTrue(viewModel.habits.isEmpty)
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        let count = try? context.count(for: request)
        XCTAssertEqual(count, 0)
    }
    
    private func addCompletion(to habit: Habit, date: Date) {
        let completion = HabitCompletion(context: context)
        completion.completedAt = date
        habit.addToCompletions(completion)
        try? context.save()
    }
    
    private func createHabit(title: String) -> Habit {
        let habit = Habit(context: context)
        habit.id = UUID()
        habit.title = title
        habit.createdAt = Date()
        try? context.save()
        return habit
    }
}
