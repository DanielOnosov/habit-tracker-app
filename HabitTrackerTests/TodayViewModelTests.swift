//
//  TodayViewModelTests.swift
//  HabitTracker
//
//  Created by Олена Кошель on 16.12.2025.
//

import XCTest
import CoreData
@testable import HabitTracker

final class TodayViewModelTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    var viewModel: TodayViewModel!
    
    override func setUp() {
        super.setUp()
        context = TestCoreDataStack.shared.context
        
        if let habits = try? context.fetch(Habit.fetchRequest()) {
            habits.forEach { context.delete($0 as! NSManagedObject) }
        }
        if let completions = try? context.fetch(HabitCompletion.fetchRequest()) {
            completions.forEach { context.delete($0 as! NSManagedObject) }
        }
        try? context.save()
        
        viewModel = TodayViewModel(context: context)
    }
    
    override func tearDown() {
        if let habits = try? context.fetch(Habit.fetchRequest()) {
            for habit in habits {
                context.delete(habit)
            }
        }
        if let completions = try? context.fetch(HabitCompletion.fetchRequest()) {
            for completion in completions {
                context.delete(completion)
            }
        }
        try? context.save()
        super.tearDown()
    }
    
    func testFilterAndLoadHabitsForToday() {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date())
        let todayIndex = (weekday + 5) % 7
        
        let h1 = Habit(context: context)
        h1.title = "Today Habit"
        h1.setSchedule([todayIndex])
        
        let tomorrowIndex = (todayIndex + 1) % 7
        let h2 = Habit(context: context)
        h2.title = "Tomorrow Habit"
        h2.setSchedule([tomorrowIndex])
        
        try? context.save()
        
        viewModel.load()
        
        XCTAssertEqual(viewModel.todayHabits.count, 1)
        XCTAssertEqual(viewModel.todayHabits.first?.title, "Today Habit")
    }
    
    func testFilterEveryDaySchedule() {
    
        let h1 = Habit(context: context)
        h1.title = "Every Day Habit"
        h1.setSchedule([])
        
        try? context.save()
        
        viewModel.load()
        
        XCTAssertEqual(viewModel.todayHabits.count, 1)
        XCTAssertEqual(viewModel.todayHabits.first?.title, "Every Day Habit")
    }
    
    func testDeleteHabitFromViewModel() {
        let h1 = Habit(context: context)
        h1.title = "To Delete"
        h1.setSchedule([])
        try? context.save()
        
        viewModel.load()
        XCTAssertEqual(viewModel.todayHabits.count, 1)
        
        viewModel.deleteHabit(0)
        
        XCTAssertTrue(viewModel.todayHabits.isEmpty)
        
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        XCTAssertEqual(try? context.count(for: request), 0)
    }
    
    func testStreakCacheUpdates() {
        let h1 = Habit(context: context)
        h1.title = "Streak Habit"
        h1.id = UUID()
        h1.setSchedule([])
        try? context.save()
        
        viewModel.load()
        XCTAssertEqual(viewModel.getStreak(habit: h1), 0)
        
        viewModel.addCompletion(h1)
        viewModel.load()
        
        XCTAssertEqual(viewModel.getStreak(habit: h1), 1)
        
        let completion = HabitCompletion(context: context)
        completion.completedAt = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        h1.addToCompletions(completion)
        try? context.save()
        
        viewModel.load()
        XCTAssertEqual(viewModel.getStreak(habit: h1), 2)
    }

    func testSortByReminderTime() {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let todayIndex = (weekday + 5) % 7
        
        let h1 = Habit(context: context)
        h1.title = "Morning"
        h1.setSchedule([todayIndex])
        h1.reminderTime = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: today)
        
        let h2 = Habit(context: context)
        h2.title = "Evening"
        h2.setSchedule([todayIndex])
        h2.reminderTime = calendar.date(bySettingHour: 20, minute: 0, second: 0, of: today)
        
        try? context.save()
        
        viewModel.load()
        
        XCTAssertEqual(viewModel.todayHabits.count, 2)
        XCTAssertEqual(viewModel.todayHabits[0].title, "Morning")
        XCTAssertEqual(viewModel.todayHabits[1].title, "Evening")
    }
    
    func testDelCompletionSpecific() {
        let habit = Habit(context: context)
        habit.id = UUID()
        try? context.save()
        
        viewModel.addCompletion(habit)
        
        let oldCompletion = HabitCompletion(context: context)
        oldCompletion.completedAt = Date().addingTimeInterval(-86400 * 30)
        habit.addToCompletions(oldCompletion)
        try? context.save()
        
        XCTAssertEqual(habit.completions?.count, 2)
        
        viewModel.delCompletion(habit)
        
        XCTAssertEqual(habit.completions?.count, 1)
        let remaining = (habit.completions?.allObjects as? [HabitCompletion])?.first
        XCTAssertNotNil(remaining)
        XCTAssertFalse(Calendar.current.isDateInToday(remaining!.completedAt!))
    }
    
    func testCacheSync() {
        let habit = Habit(context: context)
        habit.id = UUID()
        try? context.save()
        
        viewModel.load()
        XCTAssertFalse(viewModel.isCompleted(habit: habit))
        
        viewModel.toggleHabitCompletion(habit)
        XCTAssertTrue(viewModel.isCompleted(habit: habit))
  
        
        let newViewModel = TodayViewModel(context: context)
        newViewModel.load()
        XCTAssertTrue(newViewModel.isCompleted(habit: habit))
    }
    
    func testToggleCompletionAdd() {
        let habit = Habit(context: context)
        habit.id = UUID()
        habit.title = "Test Habit"
        try? context.save()
        
        viewModel.toggleHabitCompletion(habit)
        
        let completions = habit.completions as? Set<HabitCompletion>
        XCTAssertEqual(completions?.count, 1)
        XCTAssertTrue(viewModel.isCompleted(habit: habit))
    }
    

}
