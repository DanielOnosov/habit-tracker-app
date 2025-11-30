//
//  main.swift
//  HabitTrackerCLI
//
//  Created by Danylo Onosov on 22.11.2025.
//

import Foundation
import CoreData

let context = CoreDataStackCLI.shared.context

let createVM = CreateHabitViewModel(context: context)
let editVM = EditHabitViewModel(context: context)
let detailVM = HabitDetailsViewModel(context: context)
let listVM = HabitListViewModel(context: context)

let payload = HabitPayload(
    title: "test", reminderTime: Date(), color: "#000", schedule: [1,3,5]
)

print("➡️ Adding habit...")
createVM.add(payload)

print("➡️ Loading habits...")
listVM.load()
print("Habits count: \(listVM.habits.count)")

guard let habit = listVM.habits.first else {
    fatalError("❌ Habit was not created!")
}

var completion = listVM.markAsComplete(habit: habit)

let editPayload = EditHabitPayload(
    title: "new test title", reminderTime: Date(), color: "#000", schedule: [1,3,5]
)

editVM.edit(id: habit.id!, editPayload)

if let details = detailVM.findOneById(id: habit.id!) {
    print("📝 Details:")
    print("  Title: \(details.title)")
    print("  Color: \(details.color)")
    print("  Schedule: \(details.schedule)")
    print("  Streak: \(details.streakDays)")
    print("  Coefficient: \(String(format: "%.2f", details.coefficient))")
    print("  Completions: \(details.completions.count)")
}

