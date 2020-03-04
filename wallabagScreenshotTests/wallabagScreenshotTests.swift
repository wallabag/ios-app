//
//  wallabagScreenshotTests.swift
//  wallabagScreenshotTests
//
//  Created by Marinel Maxime on 03/03/2020.
//

import XCTest

class WallabagScreenshotTests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = [
            "POPULATE_APPLICATION",
        ]
    }

    func testRunScreenshot() {
        setupSnapshot(app)
        app.launch()
        snapshot("01_home")

        app.tables.firstMatch.cells.firstMatch.tap()
        snapshot("02_entry")
    }
}
