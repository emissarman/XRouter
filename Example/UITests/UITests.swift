//
//  XRouter_UITests.swift
//  XRouter_UITests
//
//  Created by Reece Como on 19/1/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest

class UITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testRoutes() {
        let app = XCUIApplication()
        app.buttons["Open \"Cameron\""].tap()
        app.buttons["Present Modal"].tap()
        app.buttons["Push View Controller"].tap()
        app.buttons["Go straight to second tab"].tap()
        wait()
        
        // Trigger Tab 2 flow
        app.buttons["Push View Controller"].tap()
        app.buttons["Reset Stack"].tap()
        wait()
        
        // Switch tabs
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Tab 1"].tap()
        tabBarsQuery.buttons["Tab 2"].tap()
        
        // Double tap Tab 1 to go home.
        tabBarsQuery.buttons["Tab 1"].tap()
        tabBarsQuery.buttons["Tab 1"].tap()
        
        // Trigger universal link
        app.buttons["Open Universal Link"].tap()
        
        // Trigger broken universal link
        tabBarsQuery.buttons["Tab 1"].tap()
        app.buttons["Attempt Broken Universal Link"].tap()
    }
    
    /// Pause for a moment
    private func wait() {
        sleep(1)
    }
    
}
