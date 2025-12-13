//
//  SceneDelegate.swift
//  HabitTracker
//
//  Created by Danylo Onosov on 20.11.2025.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let context = CoreDataStack.shared.context

        let listViewModel = HabitListViewModel(context: context)
        
        listViewModel.load(filterType: .newest)
        
        if listViewModel.habits.isEmpty {
            createInitialHabits(context: context)
            listViewModel.load(filterType: .newest)
        }
        
        let rootVC = MainTabBarController()
        
        window.rootViewController = rootVC
        self.window = window
        window.makeKeyAndVisible()
    }
}

extension SceneDelegate
{
    
    func createInitialHabits(context: NSManagedObjectContext)
    {
        let createVM = CreateHabitViewModel(context: context)
        
        let payload1 = HabitPayload(
            title: "Daily Walk (7-day streak)",
            reminderTime: Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date()),
            color: "#007AFF",
            schedule: []
        )
        createVM.add(payload1)
        
        if let habit1 = try? context.fetch(Habit.fetchRequest()).first(where: { $0.title == payload1.title }) {
            let calendar = Calendar.current
            for i in 0..<7 {
                if let pastDate = calendar.date(byAdding: .day, value: -i, to: Date()) {
                    let completion = HabitCompletion(context: context)
                    completion.completedAt = pastDate
                    habit1.addToCompletions(completion)
                }
            }
            try? context.save()
        }
        
        let payload2 = HabitPayload(
            title: "Read 10 pages",
            reminderTime: nil,
            color: "#FF9500",
            schedule: [6, 7]
        )
        createVM.add(payload2)
        
        let payload3 = HabitPayload(
            title: "Learn 5 new words",
            reminderTime: nil,
            color: "#34C759",
            schedule: [1, 2, 3, 4, 5]
        )
        createVM.add(payload3)
    }
}
