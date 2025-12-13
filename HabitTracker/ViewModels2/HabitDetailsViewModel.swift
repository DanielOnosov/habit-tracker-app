//
//  HabitDetailsViewModel.swift
//  HabitTracker
//
//  Created by Danylo Onosov on 20.11.2025.
//

// should contain logic of calculating streak, etc..., heatmap data, coefficient of doing, list when it was completed
import Foundation
import CoreData
import UserNotifications

class HabitDetailsViewModel {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func findOneById(id: UUID) -> HabitDetails? {
        let request = Habit.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        guard let habit = try? context.fetch(request).first else {
            print("Habit not found")
            return nil
        }
        
        let completions = (habit.completions as? Set<HabitCompletion>)?
            .compactMap{$0.completedAt}
            .sorted() ?? []
        
        let schedule = habit.schedule as? [Int] ?? []
        
        let streak = calculateStreak(completions: completions)
        let heatMap = generateHeatmap(completions: completions)
        let coefficient = calcCoefficient(completions: completions, createdAt: habit.createdAt ?? Date(), schedule: schedule)
        
        return HabitDetails(
            id: habit.id ?? UUID(),
            title: habit.title ?? "",
            reminderTime: habit.reminderTime,
            color: habit.color ?? "#000000",
            schedule: schedule,
            createdAt: habit.createdAt ?? Date(),
            completions: completions,
            streakDays: streak,
            heatMap: heatMap,
            coefficient: coefficient
        )
    }
    
    func calcCoefficient(completions: [Date], createdAt: Date, schedule: [Int]) -> Double
    {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var firstComplDay = completions.min() ?? createdAt
        var startDate = (firstComplDay < createdAt) ? firstComplDay : createdAt
        var curDate = calendar.startOfDay(for: startDate)
        var totalDays = 0
        var uniqueComplDays = Set(completions.map {calendar.startOfDay(for: $0)})
        
        if curDate > today
        {
            return 0.0
            
        }
        
        while curDate <= today
        {
            var weekday = calendar.component(.weekday, from: curDate)
            var dayIndex = (weekday == 1) ? 7 : (weekday - 1)
            var isScheduled: Bool
            if schedule.isEmpty || schedule.count == 7
            {
                isScheduled = true
            }
            else
            {
                isScheduled = schedule.contains(dayIndex)
            }
            
            if isScheduled == true
            {
                totalDays += 1
            }
            
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: curDate)
            {
                curDate = nextDate
            }
            else
            {
                break
            }
        }
        
        let daysComplOnSchedule = uniqueComplDays.filter
        {
            day in
            var weekday = calendar.component(.weekday, from: day)
            var scheduledDayIndex = (weekday == 1) ? 7 : (weekday - 1)
            
            if schedule.isEmpty || schedule.count == 7
            {
                return true
                
            }
            return schedule.contains(scheduledDayIndex)
        }.count
        
        var a = Double(max(totalDays, 1))
        var b = Double(daysComplOnSchedule)
        
        var result = b / a
        return min(result, 1.0)
    }
    
    private func generateHeatmap(completions: [Date]) -> [Date: Bool] {
        var map: [Date: Bool] = [:]
        let calendar = Calendar.current
        
        for date in completions {
            let day = calendar.startOfDay(for: date)
            map[day] = true
        }
        
        return map
    }
    
    func calculateStreak(completions: [Date]) -> Int {
        guard !completions.isEmpty else { return 0 }
        
        var streak = 0
        let calendar = Calendar.current
        
        let uniqueComplDays = Set(completions.map { calendar.startOfDay(for: $0) })
        
        var checkDate = calendar.startOfDay(for: Date())
    
        if !uniqueComplDays.contains(checkDate)
        {
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: checkDate) else { return 0 }
            checkDate = yesterday
        }
        
        while uniqueComplDays.contains(checkDate)
        {
            streak += 1
            guard let previousDate = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
            checkDate = previousDate
        }

        return streak
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save habit: \(error)")
        }
    }
}
