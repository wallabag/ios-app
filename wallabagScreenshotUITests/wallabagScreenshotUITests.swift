//  Created by maxime marinel on 19/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import XCTest

class SnapshotUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testScreenshotProcess() {
        let app = XCUIApplication()
        app.launchArguments = ["RESET_APPLICATION"]
        app.launch()

        let registerButton = app.buttons["Register"]
        XCTAssertTrue(registerButton.isEnabled)

        app.buttons["Register"].tap()

        let serverTextField = app.textFields["Server"]
        serverTextField.tap()
        serverTextField.typeText("http://wallabag.maxime.marinel.me")

        let nextButton = app.buttons["Next"]
        nextButton.tap()

        let clientidTextField = app.textFields["ClientId"]
        clientidTextField.tap()
        clientidTextField.typeText("3_26wjjwi43i1w0oss400k8gw8gkck4wgg8ocsco8g4w8040sksw")

        let clientsecretTextField = app.textFields["ClientSecret"]
        clientsecretTextField.tap()
        clientsecretTextField.typeText("555z72uyvqko40o8k0cc0sk4ocog0sogg40okws4sooc4o8k8k")
        nextButton.tap()

        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("demo")

        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("demo")
        nextButton.tap()

        snapshot("01Home")

        app.tables.cells.element(boundBy: 0).tap()

        snapshot("02Article")
    }
}
