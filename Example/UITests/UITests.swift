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
        app.buttons["Push View Controller"].tap()
        app.buttons["Reset Stack"].tap()
        wait()
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Tab 1"].tap()
        tabBarsQuery.buttons["Tab 2"].tap()
        
    }
    
    /// Pause for a moment
    private func wait() {
        sleep(1)
    }
    
}
