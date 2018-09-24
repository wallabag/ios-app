//
//  RegisterProcessUITests.swift
//  wallabag
//
//  Created by maxime marinel on 03/01/2017.
//  Copyright © 2017 maxime marinel. All rights reserved.
//

import XCTest

class RegisterProcessUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["-inUITest",
                               "-AppleLanguages",
                               "(en)",
                               "-AppleLocale",
                               "en_EN",
                               "-reset"]
        app.launch()
    }

    func testRegisteringSuccess() {
        let app = XCUIApplication()
        let registerButton = app.buttons["Home.Register.Button"]
        XCTAssertTrue(registerButton.isEnabled)

        registerButton.tap()

        let serverTextField = app.textFields["Server.Server.TextField"]
        serverTextField.tap()
        serverTextField.typeText("http://wallabag.maxime.marinel.me")

        app.buttons["Server.Next.Button"].tap()

        let clientidTextField = app.textFields["ClientId.ClientId.TextField"]
        clientidTextField.tap()
        clientidTextField.typeText("2_5c32wcr27p4wkk8k8k8s800g8g488ocsss8wwcs4s0s44wcos")

        let clientsecretTextField = app.textFields["ClientId.ClientSecret.TextField"]
        clientsecretTextField.tap()
        clientsecretTextField.typeText("5wy501ku6z8c4w84gg4wcgs8k0ks08s0c0gk8co00gwc4ssgco")
        app.buttons["ClientId.Next.Button"].tap()

        let usernameTextField = app.textFields["Login.Username.TextField"]
        usernameTextField.tap()
        usernameTextField.typeText("dev")

        let passwordSecureTextField = app.secureTextFields["Login.Password.TextField"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("dev")
        app.buttons["Login.Next.Button"].tap()

        XCTAssertEqual(1, app.tables.count)
        XCTAssertTrue(app.navigationBars["All articles"].exists)
    }

    func testRegisteringWithInvalidURLThenFailWithAlertMsg() {
        let app = XCUIApplication()
        app.buttons["Home.Register.Button"].tap()

        XCTAssertFalse(app.alerts["Error"].exists)

        let serverTextField = app.textFields["Server.Server.TextField"]
        serverTextField.tap()
        serverTextField.typeText("wallabag.maxime.marinel.me")
        app.buttons["Next"].tap()

        XCTAssertTrue(app.alerts["Error"].exists)
        XCTAssertTrue(app.alerts["Error"].staticTexts["Whoops looks like something went wrong. Check the url, don't forget http or https"].exists)
    }

    func testRegisteringWithInvalidClientIdAndSecretThenFailWithAlertMsg() {
        let app = XCUIApplication()

        let registerButton = app.buttons["Home.Register.Button"]
        XCTAssertTrue(registerButton.isEnabled)
        registerButton.tap()

        let serverTextField = app.textFields["Server.Server.TextField"]
        serverTextField.tap()
        serverTextField.typeText("http://wallabag.maxime.marinel.me")

        app.buttons["Server.Next.Button"].tap()

        let clientidTextField = app.textFields["ClientId.ClientId.TextField"]
        clientidTextField.tap()
        clientidTextField.typeText("wrong_client")

        let clientsecretTextField = app.textFields["ClientId.ClientSecret.TextField"]
        clientsecretTextField.tap()
        clientsecretTextField.typeText("wrong_secret")
        app.buttons["ClientId.Next.Button"].tap()

        XCTAssertFalse(app.alerts["Error"].exists)
        let usernameTextField = app.textFields["Login.Username.TextField"]
        usernameTextField.tap()
        usernameTextField.typeText("dev")

        let passwordSecureTextField = app.secureTextFields["Login.Password.TextField"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("dev")
        app.buttons["Login.Next.Button"].tap()
        XCTAssertTrue(app.alerts["invalid_client"].exists)
        XCTAssertTrue(app.alerts["invalid_client"].staticTexts["The client credentials are invalid"].exists)
    }
}
