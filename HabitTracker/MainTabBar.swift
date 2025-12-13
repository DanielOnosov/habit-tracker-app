//
//  MainTabBar.swift
//  HabitTracker
//
//  Created by Dasha on 13.12.2025.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }

    func setupTabs()
    {
        let context = CoreDataStack.shared.context
        let todayVM = TodayViewModel(context: context)
        let todayVC = TodayView(viewModel: todayVM)
        
        let todayNav = UINavigationController(rootViewController: todayVC)
        todayNav.tabBarItem = UITabBarItem(
            title: "Today",
            image: UIImage(systemName: "calendar"),
            selectedImage: UIImage(systemName: "calendar.circle.fill")
        )
        let listVM = HabitListViewModel(context: context)
        let listVC = HabitTrackerView(viewModel: listVM)
        listVC.title = "All Habits"
        let listNav = UINavigationController(rootViewController: listVC)
        listNav.tabBarItem = UITabBarItem(
            title: "Habits",
            image: UIImage(systemName: "list.bullet"),
            selectedImage: UIImage(systemName: "list.bullet.circle.fill")
        )

        self.viewControllers = [todayNav, listNav]
    }
    
    func setupAppearance()
    {
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .systemGray
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
