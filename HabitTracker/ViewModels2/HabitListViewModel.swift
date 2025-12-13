//
//  HabitListViewModel.swift
//  HabitTracker
//
//  Created by Danylo Onosov on 20.11.2025.
//

import CoreData

enum HabitFilter
{
    case alpha
    case newest
    case streak
}

final class HabitListViewModel {
    private(set) var habits: [Habit] = []
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func load(filterType: HabitFilter)
    {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        
        switch filterType
        {
        case .alpha:
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        case .newest:
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        case .streak:
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        }

        do
        {
            self.habits = try context.fetch(request)
            
            if filterType == .streak
            {
                self.habits.sort
                {
                    h1, h2 in
                    let s1 = calcStreak(for: h1)
                    let s2 = calcStreak(for: h2)
                    return s1 > s2
                }
            }
            
        }
        catch
        {
            print("Error loading habits: \(error)")
        }
    }
    
    func calcStreak(for habit: Habit) -> Int {
        var complSet = habit.completions as? Set<HabitCompletion> ?? []
        var dates = complSet
            .compactMap { $0.completedAt }
            .sorted(by: { $0 > $1 })
        
        if dates.isEmpty
        {
            return 0
        }
        
        var calendar = Calendar.current
        var streak = 1
        var refDate = calendar.startOfDay(for: dates[0])
        
        for i in 1..<dates.count
        {
            let prevday = calendar.startOfDay(for: dates[i])
            if let expDate = calendar.date(byAdding: .day, value: -1, to: refDate), calendar.isDate(prevday, inSameDayAs: expDate)
            {
                streak += 1
                refDate = prevday
            }
            else if calendar.isDate(prevday, inSameDayAs: refDate)
            {
                continue
            }
            else
            {
                break
            }
        }
        
        return streak
    }
    
    func delete(_ habit: Habit)
    {
        context.delete(habit)
        try? context.save()
        if let index = habits.firstIndex(of: habit)
        {
            habits.remove(at: index)
        }
    }
}
