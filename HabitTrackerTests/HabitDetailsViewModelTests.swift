//
//  HabitDetailsViewModelTests.swift
//  HabitTrackerTests
//
//  Created by Олена Кошель on 16.12.2025.
//

import XCTest
import CoreData
@testable import HabitTracker

final class HabitDetailsViewModelTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    var viewModel: HabitDetailsViewModel!
    
    override func setUp() {
        super.setUp()
        context = TestCoreDataStack.shared.context
        viewModel = HabitDetailsViewModel(context: context)
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

   
    func testCalculateStreakEmpty() {
        let streak = viewModel.calculateStreak(completions: [])
        XCTAssertEqual(streak, 0)
    }
    
    func testCalculateStreakContinuous() {
       
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let dayBefore = Calendar.current.date(byAdding: .day, value: -2, to: today)!
        
        let streak = viewModel.calculateStreak(completions: [today, yesterday, dayBefore])
        XCTAssertEqual(streak, 3)
    }
    
    func testCalculateStreakBroken() {
       
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let fourDaysAgo = Calendar.current.date(byAdding: .day, value: -4, to: today)!
        
        let streak = viewModel.calculateStreak(completions: [today, yesterday, fourDaysAgo])
       
        XCTAssertEqual(streak, 2)
    }
    
    func testCalculateStreakYesterdayOnly() {
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        
        let streak = viewModel.calculateStreak(completions: [yesterday])
        XCTAssertEqual(streak, 1)
    }
    
  
    func testCoefficientPerfect() {
        
        let today = Date()
        let fiveDaysAgo = Calendar.current.date(byAdding: .day, value: -4, to: today)!
        
        let completions = (0...4).compactMap { Calendar.current.date(byAdding: .day, value: -$0, to: today) }
        
       
        let schedule: [Int] = []
        
        let coeff = viewModel.calcCoefficient(completions: completions, createdAt: fiveDaysAgo, schedule: schedule)
        
        XCTAssertEqual(coeff, 1.0, accuracy: 0.01)
    }
    
    func testCoefficientHalf() {
        
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        let completions = [today]
        let schedule: [Int] = []
        
        let coeff = viewModel.calcCoefficient(completions: completions, createdAt: yesterday, schedule: schedule)
        
       
        XCTAssertEqual(coeff, 0.5, accuracy: 0.01)
    }
    
    func testCoefficientWithSchedule() {
        
        let calendar = Calendar.current
        var components = DateComponents()
        components.weekday = 2
        let today = Date()
        let previousMonday = calendar.nextDate(after: today, matching: components, matchingPolicy: .nextTime, direction: .backward)!
        
        let completions = [previousMonday]
        
        let coeff = viewModel.calcCoefficient(completions: completions, createdAt: previousMonday, schedule: [1])
        
        XCTAssertEqual(coeff, 1.0, accuracy: 0.01)
    }
    
    func testCoefficientFutureDateEdgeCase() {
   
        let future = Calendar.current.date(byAdding: .day, value: 5, to: Date())!
        let coeff = viewModel.calcCoefficient(completions: [], createdAt: future, schedule: [])
        XCTAssertEqual(coeff, 0.0)
    }
    
    func testGenerateHeatmap() {
     
        
        let habit = Habit(context: context)
        habit.id = UUID()
        habit.title = "Heatmap Habit"
        habit.createdAt = Date()
        
        let today = Calendar.current.startOfDay(for: Date())
        let c1 = HabitCompletion(context: context)
        c1.completedAt = today
        habit.addToCompletions(c1)
        
        try? context.save()
        
        guard let details = viewModel.findOneById(id: habit.id!) else {
            XCTFail("Found no details")
            return
        }
        
        XCTAssertTrue(details.heatMap[today] == true)
        XCTAssertNil(details.heatMap[Date().addingTimeInterval(-86400 * 10)])
        
    }
    
    func testFindOneById() {
        let habit = Habit(context: context)
        habit.id = UUID()
        habit.title = "Detailed Habit"
        habit.schedule = [1, 2, 3] as NSArray
        habit.createdAt = Date()
        
        let completion = HabitCompletion(context: context)
        completion.completedAt = Date()
        habit.addToCompletions(completion)
        
        try? context.save()
        
        guard let details = viewModel.findOneById(id: habit.id!) else {
            XCTFail("Should find habit details")
            return
        }
        
        XCTAssertEqual(details.title, "Detailed Habit")
        XCTAssertEqual(details.streakDays, 1)
        XCTAssertFalse(details.completions.isEmpty)
    }
}
