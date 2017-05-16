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
        clientidTextField.typeText("2_5c32wcr27p4wkk8k8k8s800g8g488ocsss8wwcs4s0s44wcos")

        let clientsecretTextField = app.textFields["ClientSecret"]
        clientsecretTextField.tap()
        clientsecretTextField.typeText("5wy501ku6z8c4w84gg4wcgs8k0ks08s0c0gk8co00gwc4ssgco")
        nextButton.tap()

        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText("dev")

        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("dev")
        nextButton.tap()

        snapshot("01Home")

        app.tables.cells.element(boundBy: 0).tap()

        snapshot("02Article")
    }
}
