//
//  HabitDetails.swift
//  HabitTracker
//
//  Created by Danylo Onosov on 24.11.2025.
//

import Foundation

struct HabitDetails {
    var id: UUID
    var title: String
    var reminderTime: Date?
    var color: String
    var schedule: [Int]
    var createdAt: Date
    var completions: [Date]
    
    // computed fields
    var streakDays: Int
    var heatMap: [Date: Bool]
    var coefficient: Double
}
