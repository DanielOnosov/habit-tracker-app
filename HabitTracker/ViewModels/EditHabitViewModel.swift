//
//  CreateHabitModel.swift
//  HabitTracker
//
//  Created by Danylo Onosov on 20.11.2025.
//

// should contain edit habit by id logic
// and replan notifications
import Foundation
import CoreData
import UserNotifications

class EditHabitViewModel {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func edit(id: UUID, _ payload: EditHabitPayload) {
        let request = Habit.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        guard let habit = try? context.fetch(request).first else {
            print("Habit not found")
            return
        }
        
        if let title = payload.title {
            habit.title = title
        }
        if let color = payload.color {
            habit.color = color
        }
        if let schedule = payload.schedule {
            habit.schedule = schedule as NSArray
        }
        if let reminderTime = payload.reminderTime {
            habit.reminderTime = reminderTime
            
            rescheduleNotification(for: habit, at: reminderTime)
        }
        
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save habit: \(error)")
        }
    }
    
    private func rescheduleNotification(for habit: Habit, at date: Date) {
//        let id = habit.objectID.uriRepresentation().absoluteString
//        
//        UNUserNotificationCenter.current()
//            .removePendingNotificationRequests(withIdentifiers: [id])
//        
//        let content = UNMutableNotificationContent()
//        content.title = "Habit Reminder"
//        content.body = "Don't forget your habit: \(habit.title)"
//        content.sound = .default
//        
//        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: date)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
//        
//        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
//        
//        UNUserNotificationCenter.current().add(request) { err in
//            if let err = err {
//                print("Notification error: \(err)")
//            }
//        }
    }
}
