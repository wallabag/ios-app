//
//  ArticlesUITests.swift
//  wallabag
//
//  Created by maxime marinel on 13/05/2017.
//  Copyright © 2017 maxime marinel. All rights reserved.
//

import XCTest

class ArticlesUITests: XCTestCase {

    private func addArticle() {
        let app = XCUIApplication()
        app.navigationBars.buttons["Add"].tap()
        let alert = app.alerts["Add link"]

        alert.collectionViews.textFields["Url"].typeText("www.annonces-airsoft.fr")
        alert.buttons["Add"].tap()
    }

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()

        let app = XCUIApplication()
        app.launchArguments = ["-inUITest",
                               "-AppleLanguages",
                               "(en)",
                               "-AppleLocale",
                               "en_EN",
                               "RESET_APPLICATION"]
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
    }

    func testAddAndDeleteArticle() {
        let app = XCUIApplication()

        XCTAssertFalse(app.alerts["Add link"].exists)
        app.navigationBars.buttons["Add"].tap()

        let alert = app.alerts["Add link"]
        XCTAssertTrue(alert.exists)

        alert.collectionViews.textFields["Url"].typeText("www.annonces-airsoft.fr")
        alert.buttons["Add"].tap()
    }

    func testStarArticle() {
        let app = XCUIApplication()

        addArticle()

        let cell = app.tables.cells.element(boundBy: 0)

        cell.swipeLeft()
        XCTAssertTrue(cell.buttons["Star"].exists)
        cell.buttons["Star"].tap()
        cell.swipeLeft()
        XCTAssertTrue(cell.buttons["Unstar"].exists)
        cell.swipeLeft()
        cell.buttons["Unstar"].tap()
        cell.swipeLeft()
        XCTAssertTrue(cell.buttons["Star"].exists)
    }
}
