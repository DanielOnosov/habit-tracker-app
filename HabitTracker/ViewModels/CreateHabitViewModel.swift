//
//  CreateHabitModel.swift
//  HabitTracker
//
//  Created by Danylo Onosov on 20.11.2025.
//

// should contain add habit logic
// and planning notifications
import CoreData
import UserNotifications

class CreateHabitViewModel {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func add(_ payload: HabitPayload) {
        let habit = Habit(context: self.context)
        habit.title = payload.title
        habit.color = payload.color
        habit.schedule = payload.schedule as NSArray
        habit.reminderTime = payload.reminderTime
        habit.createdAt = Date.now
        habit.id = UUID()
        
        if let time = payload.reminderTime {
            scheduleNotification(for: habit, at: time)
        }
        
        saveContext()
    }
    
    private func saveContext() {
           do {
               try context.save()
           } catch {
               print("Failed to save habit: \(error)")
           }
       }
    
    private func scheduleNotification(for habit: Habit, at date: Date) {
//        let content = UNMutableNotificationContent()
//        content.title = "Habit Reminder"
//        content.body = "Don't forget your habit: \(habit.title)"
//        content.sound = .default
//        
//        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: date)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
//        
//        let request = UNNotificationRequest(
//            identifier: habit.objectID.uriRepresentation().absoluteString,
//            content: content,
//            trigger: trigger
//        )
//        
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Error scheduling notification: \(error)")
//            }
//        }
    }
}

