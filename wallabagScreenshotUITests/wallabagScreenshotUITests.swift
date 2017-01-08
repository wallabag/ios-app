
//  Created by maxime marinel on 19/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import XCTest

class snapshotUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testScreenshotProcess() {
        let app = XCUIApplication()
        setupSnapshot(app)
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
        clientidTextField.typeText("2_2vw9bl00nn6sk4skscc408wswk80gscg8o88swsw8ow4wkgccs")

        let clientsecretTextField = app.textFields["ClientSecret"]
        clientsecretTextField.tap()
        clientsecretTextField.typeText("30vyapj31jgg4cgw8s00k0go4cc0osgk0048cwooow4cc8o004")
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
