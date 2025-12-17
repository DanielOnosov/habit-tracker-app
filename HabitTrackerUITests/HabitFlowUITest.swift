//
//  HabitFlowUITests.swift
//  HabitTrackerUITests
//
//  Created by Олена Кошель on 16.12.2025.
//
import XCTest

final class HabitFlowUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAppLaunch() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.tabBars.buttons.element(boundBy: 0).exists)
    }

    func testTabNavigation() {
        let app = XCUIApplication()
        app.launch()
        
        let tab1 = app.tabBars.buttons.element(boundBy: 0)
        let tab2 = app.tabBars.buttons.element(boundBy: 1)
        
        tab2.tap()
        XCTAssertTrue(app.navigationBars.buttons["Add"].exists)
        
        tab1.tap()
        XCTAssertTrue(tab1.isSelected)
    }

    func testOpenAddScreen() {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        app.navigationBars.buttons["Add"].tap()
        XCTAssertTrue(app.textFields.firstMatch.waitForExistence(timeout: 2))
    }

    func testAddScreenElements() {
        let app = XCUIApplication()
        app.launch()
        navigateToCreate(app)
        
        XCTAssertTrue(app.textFields.firstMatch.exists)
        XCTAssertTrue(app.buttons["Create"].exists || app.buttons["CreateHabitButton"].exists)
    }

    func testFilterMenu() {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        if app.navigationBars.buttons.element(boundBy: 0).exists {
           
            
            XCTAssertTrue(app.navigationBars.buttons.element(boundBy: 0).isHittable)
        }
    }
    
    func testEmptyStateToday() {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons.element(boundBy: 0).tap()
  
        XCTAssertTrue(app.tables.element(boundBy: 0).exists)
    }

    func testEmptyStateHabits() {
        let app = XCUIApplication()
        app.launch()
        app.tabBars.buttons.element(boundBy: 1).tap()
        XCTAssertTrue(app.tables.element(boundBy: 0).exists)
    }
    
    func navigateToCreate(_ app: XCUIApplication) {
        app.tabBars.buttons.element(boundBy: 1).tap()
        app.navigationBars.buttons["Add"].tap()
        XCTAssertTrue(app.textFields.firstMatch.waitForExistence(timeout: 3))
    }
}
