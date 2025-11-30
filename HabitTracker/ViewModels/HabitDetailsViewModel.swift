//
//  CreateHabitModel.swift
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
        let coefficient = calculateCoefficient(completions: completions, createdAt: habit.createdAt ?? Date())
        
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
    
    private func calculateCoefficient(completions: [Date], createdAt: Date) -> Double {
        let calendar = Calendar.current
        let daysActive = calendar.dateComponents([.day], from: createdAt, to: Date()).day ?? 1
        
        let uniqueDaysCompleted = Set(
            completions.map { calendar.startOfDay(for: $0) }
        ).count
        
        return Double(uniqueDaysCompleted) / Double(max(daysActive, 1))
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
    
    private func calculateStreak(completions: [Date]) -> Int {
        guard !completions.isEmpty else { return 0 }
        
        var streak = 0
        var currentDate = Date()
        let calendar = Calendar.current
        
        while true {
            if completions.contains(where: { calendar.isDate($0, inSameDayAs: currentDate) }) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break
            }
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
