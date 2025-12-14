////
////  main.swift
////  HabitTrackerCLI
////
////  Created by Danylo Onosov on 22.11.2025.
////
//
//import Foundation
//import CoreData
//
//let context = CoreDataStackCLI.shared.context
//
//let createVM = CreateHabitViewModel(context: context)
//let detailVM = HabitDetailsViewModel(context: context)
//let listVM = HabitListViewModel(context: context)
//
//let payload = HabitPayload(
//    title: "test", reminderTime: Date(), color: "#000", schedule: [1,3,5]
//)
//
//print("➡️ Adding habit...")
//createVM.add(payload)
//
//print("➡️ Loading habits...")
//listVM.load(filterType: .newest)
//print("Habits count: \(listVM.habits.count)")
//
//guard let habit = listVM.habits.first, let habitID = habit.id else {
//    fatalError("❌ Habit was not created or has no ID!")
//}
//
//// If you need to edit, construct EditHabitViewModel with habitID
//let editVM = EditHabitViewModel(context: context, habitID: habitID)
//
//// Note: HabitListViewModel in this project does not define markAsComplete.
//// If you intended to toggle completion, use TodayViewModel or your own method.
//// var completion = listVM.markAsComplete(habit: habit)
//
//let editPayload = EditHabitPayload(
//    title: "new test title", reminderTime: Date(), color: "#000", schedule: [1,3,5]
//)
//
//editVM.edit(id: habitID, editPayload)
//
//if let details = detailVM.findOneById(id: habitID) {
//    print("📝 Details:")
//    print("  Title: \(details.title)")
//    print("  Color: \(details.color)")
//    print("  Schedule: \(details.schedule)")
//    print("  Streak: \(details.streakDays)")
//    print("  Coefficient: \(String(format: "%.2f", details.coefficient))")
//    print("  Completions: \(details.completions.count)")
//}
