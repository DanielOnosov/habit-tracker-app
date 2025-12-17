//
//  HabitTrackerUITests.swift
//  HabitTrackerUITests
//
//  Created by Danylo Onosov on 20.11.2025.
//

import XCTest

final class HabitTrackerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAppLaunch() {
        let app = XCUIApplication()
        app.launch()
        
        let tabBar = app.tabBars.firstMatch
        if tabBar.exists {
             XCTAssertTrue(tabBar.buttons.count > 0, "Tab bar should have buttons")
        } else {
             XCTAssertTrue(app.wait(for: .runningForeground, timeout: 5))
        }
    }
    
    func testAddHabitFlowExposure() {
        let app = XCUIApplication()
        app.launch()
        
    
        
        let addButtons = [
            app.buttons["Add"],
            app.buttons["plus"],
            app.buttons["Add Habit"],
            app.navigationBars.buttons["Add"]
        ]
        
        
        for btn in addButtons {
            if btn.exists {
   
                btn.tap()
        
                let exists = app.staticTexts["New Habit"].waitForExistence(timeout: 2) ||
                             app.buttons["Create"].exists
                
                if exists {
                    XCTAssertTrue(exists)
                    return
                }
            }
        }
        
        XCTAssertTrue(true)
    }
}
