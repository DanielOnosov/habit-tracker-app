//
//  Habit+Schedule.swift
//  HabitTracker
//
//  Created by alina on 14.12.2025.
//

import Foundation

extension Habit {
    var scheduleInts: [Int] {
        if let nsArray = schedule as? NSArray {
            return nsArray.compactMap {
                if let num = $0 as? NSNumber { return num.intValue }
                if let intVal = $0 as? Int { return intVal }
                return nil
            }
        }
        return []
    }

    func setSchedule(_ days: [Int]) {
        self.schedule = days.map { NSNumber(value: $0) } as NSArray
    }
}
