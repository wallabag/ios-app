//
//  LoginViewControllerTests.swift
//  wallabagTests
//
//  Created by maxime marinel on 16/04/2019.
//

import Swinject
import SwinjectStoryboard
@testable import wallabag
import XCTest

class LoginViewControllerTests: XCTestCase {
    let container = Container()
    var storyboard: SwinjectStoryboard!
    var bundle: Bundle = Bundle(identifier: "fr.district-web.wallabag")!
    var analyticsMock: AnalyticsManagerMock = AnalyticsManagerMock()
    var loginController: LoginViewController!

    override func setUp() {
        storyboard = SwinjectStoryboard.create(name: "Registration", bundle: bundle, container: container)
        container.register(AnalyticsManagerMock.self) { _ in self.analyticsMock }
    }

    func testViewDidLoad() {
        container.register(SettingMock.self) { _ in
            SettingMock(["username": "my_username"])
        }
        container.storyboardInitCompleted(LoginViewController.self) { r, c in
            c.analytics = r.resolve(AnalyticsManagerMock.self)
            c.setting = r.resolve(SettingMock.self)
        }
        loginController = (storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController)
        UIApplication.shared.keyWindow?.rootViewController = loginController

        XCTAssertEqual(AnalyticsManager.AnalyticsViewEvent.loginView, analyticsMock.eventScreenView)
        XCTAssertEqual("my_username", loginController.username.text)
    }

    #warning("Missing test on login")
}
