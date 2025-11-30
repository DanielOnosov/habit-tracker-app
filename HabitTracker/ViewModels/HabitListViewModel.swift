//
//  CreateHabitModel.swift
//  HabitTracker
//
//  Created by Danylo Onosov on 20.11.2025.
//

import CoreData

final class HabitListViewModel {
    private(set) var habits: [Habit] = []
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func load() {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        
        do {
            self.habits = try context.fetch(request)
        } catch {
            print("Error loading habits: \(error)")
        }
    }
    
    func markAsComplete(habit: Habit) -> Bool {
        let calendar = Calendar.current
        
        if let completions = habit.completions as? Set<HabitCompletion>,
           completions.contains(where: {
               guard let date = $0.completedAt else { return false }
               return calendar.isDateInToday(date)
           }) {
            print("completed today")
            return false
        }
        
        let completion = HabitCompletion(context: context)
        completion.completedAt = Date()
        habit.addToCompletions(completion)
        
        saveContext()
        context.refresh(habit, mergeChanges: true)
        return true
    }
    
    func removeCompletion(habit: Habit) -> Bool {
        guard let completions = habit.completions as? Set<HabitCompletion>,
              let last = completions.sorted(by: {
                  ($0.completedAt ?? .distantPast) < ($1.completedAt ?? .distantPast)
              }).last else {
            return false
        }
        
        habit.removeFromCompletions(last)
        context.delete(last)
        
        saveContext()   
        context.refresh(habit, mergeChanges: true)
        return true
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save habit: \(error)")
        }
    }
}
