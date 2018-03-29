//
//  MetraScreenshots.swift
//  MetraScreenshots
//
//  Created by Andrew Finke on 8/5/17.
//  Copyright © 2017 Andrew Finke. All rights reserved.
//

import XCTest

class MetraScreenshots: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testScreenshot() {
        let tabBarsQuery = app.tabBars
        if UI_USER_INTERFACE_IDIOM() == .pad {
            XCUIDevice.shared.orientation = .landscapeLeft
        } else {
            XCUIDevice.shared.orientation = .portrait
        }
        sleep(5)
        tabBarsQuery.buttons["Alerts"].tap()
        sleep(2)
        snapshot("c_Alerts")
        tabBarsQuery.buttons["Map"].tap()
        snapshot("a_Map")
        app.navigationBars["Metra Live Map"].buttons["Filter"].tap()
        snapshot("b_Filter")
    }

}
