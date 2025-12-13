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
        habit.schedule = payload.schedule.map { NSNumber(value: $0) } as NSArray
        habit.reminderTime = payload.reminderTime
        habit.createdAt = Date()
        habit.id = UUID()

        if let time = payload.reminderTime {
            scheduleNotification(for: habit, at: time)
        }

        saveContext()
    }

    private func saveContext() {
        do {
            try context.save()
            print("saved?")
        } catch {
            print("Failed to save habit: \(error)")
        }
    }

    private func scheduleNotification(for habit: Habit, at date: Date) {
        let content = UNMutableNotificationContent()
        let center = UNUserNotificationCenter.current()

        content.title = "Habit Reminder"
        let habitTitle = habit.title ?? "Your habit"
        content.body = "Don't forget your habit: \(habitTitle)"
        content.sound = .default

        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents(
            [.hour, .minute],
            from: date
        )

        let schedule: [Int] = {
            if let array = habit.schedule as? [NSNumber] {
                return array.map { $0.intValue }
            }
            if let nsArray = habit.schedule as? NSArray {
                return nsArray.compactMap { ($0 as? NSNumber)?.intValue }
            }
            return []
        }()

        let habitId = habit.id ?? UUID()

        if schedule.isEmpty {
            // One-time notification at the given time today (or next occurrence if time already passed, per system behavior)
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: timeComponents,
                repeats: false
            )

            let request = UNNotificationRequest(
                identifier: habitId.uuidString,
                content: content,
                trigger: trigger
            )

            center.add(request)
            return
        }

        // Weekly repeating notifications for selected weekdays
        for day in schedule {
            var components = timeComponents
            // UNCalendarNotificationTrigger expects weekday 1...7 where 1 = Sunday
            components.weekday = day + 1

            let trigger = UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: true
            )

            let request = UNNotificationRequest(
                identifier: "\(habitId.uuidString)_day\(day)",
                content: content,
                trigger: trigger
            )

            center.add(request)
        }
    }
}
