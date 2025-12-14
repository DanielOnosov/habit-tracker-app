//
//  TodayViewModel.swift
//  HabitTracker
//
//  Created by Dasha on 13.12.2025.
//

import Foundation
import CoreData

final class TodayViewModel
{
    private(set) var todayHabits: [Habit] = []
    let context: NSManagedObjectContext
    var complStatus: [UUID: Bool] = [:]
    var streakCache: [UUID: Int] = [:]
    
    init(context: NSManagedObjectContext)
    {
        self.context = context
    }
    
    func load()
    {
        filterAndLoadHabits()
        updateCache()
    }
    
    func filterAndLoadHabits()
    {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "reminderTime", ascending: true)]
        
        do
        {
            let allHabits = try context.fetch(request)
            let calendar = Calendar.current
            
            let weekday = calendar.component(.weekday, from: Date())
//            let curDayIndex = (weekday == 1) ? 7 : (weekday - 1)
            let curDayIndex = (weekday + 5) % 7
            
//            for habit in allHabits {
//                print("Habit: \(habit.title ?? "no title")")
//                if let sched = habit.schedule as? NSArray {
//                    print("Schedule (NSArray): \(sched)")
//                } else {
//                    print("Schedule is nil or not NSArray")
//                }
//            }

            
            self.todayHabits = allHabits.filter { habit in
//                if let schedule = habit.schedule as? [Int] {
//                    if schedule.isEmpty
//                    {
//                        return true
//                    }
//                    return schedule.contains(curDayIndex)
//                }
//                else
//                {
//                    return true
//                }
                let schedule = habit.scheduleInts
                if schedule.isEmpty { return true }
                return schedule.contains(curDayIndex)


            }
        }
        catch
        {
            print("Error loading habits: \(error)")
        }
    }
    
    func updateCache()
    {
        let calendar = Calendar.current
        let detailsVM = HabitDetailsViewModel(context: context)
        
        for habit in todayHabits
        {
            guard let id = habit.id else { continue }
            if let completions = habit.completions as? Set<HabitCompletion>
            {
                let isCompleted = completions.contains
                {
                    completion in
                    return completion.completedAt.map { calendar.isDateInToday($0) } ?? false
                }
                complStatus[id] = isCompleted
                
                let dates = completions.compactMap { $0.completedAt }.sorted()
                streakCache[id] = detailsVM.calculateStreak(completions: dates)
            }
            else
            {
                complStatus[id] = false
                streakCache[id] = 0
            }
        }
    }
    
    func isCompleted(habit: Habit) -> Bool
    {
        return habit.id.flatMap { complStatus[$0] } ?? false
    }
    
    func getStreak(habit: Habit) -> Int
    {
        return habit.id.flatMap { streakCache[$0] } ?? 0
    }
    
    func toggleHabitCompletion(_ habit: Habit)
    {
        let isDone = isCompleted(habit: habit)
        
        if isDone
        {
            delCompletion(habit)
        } else
        {
            addCompletion(habit)
        }
        
        load()
    }
    
    func addCompletion(_ habit: Habit)
    {
        let completion = HabitCompletion(context: context)
        completion.completedAt = Date()
        habit.addToCompletions(completion)
        saveContext()
    }
    
    func delCompletion(_ habit: Habit)
    {
        let calendar = Calendar.current
        if let completions = habit.completions as? Set<HabitCompletion>
        {
            if let todayCompletion = completions.first(where: { completion in
                return completion.completedAt.map { calendar.isDateInToday($0) } ?? false
            })
            {
                habit.removeFromCompletions(todayCompletion)
                context.delete(todayCompletion)
                saveContext()
            }
        }
    }
    
    func deleteHabit(_ index: Int)
    {
        let habit = todayHabits[index]
        context.delete(habit)
        saveContext()
        todayHabits.remove(at: index)
    }
    
    func saveContext()
    {
        try? context.save()
    }
}
