//
//  ServerViewControllerTests.swift
//  wallabagTests
//
//  Created by maxime marinel on 10/04/2019.
//

import Swinject
import SwinjectStoryboard
@testable import wallabag
import WallabagCommon
import XCTest

class ServerViewControllerTests: XCTestCase {
    let container = Container()
    var storyboard: SwinjectStoryboard!
    var bundle: Bundle = Bundle(identifier: "fr.district-web.wallabag")!
    var analyticsMock: AnalyticsManagerMock = AnalyticsManagerMock()
    var serverController: ServerViewController!

    override func setUp() {
        storyboard = SwinjectStoryboard.create(name: "Registration", bundle: bundle, container: container)
        container.register(AnalyticsManagerMock.self) { _ in self.analyticsMock }
    }

    func testWithServerConfiguredInSetting() {
        container.register(SettingMock.self) { _ in
            SettingMock(["host": "http://my.server.wallabag"])
        }
        container.storyboardInitCompleted(ServerViewController.self) { r, c in
            c.analytics = r.resolve(AnalyticsManagerMock.self)
            c.setting = r.resolve(SettingMock.self)
        }
        serverController = (storyboard.instantiateViewController(withIdentifier: "ServerViewController") as! ServerViewController)
        _ = serverController.view
        XCTAssertEqual("http://my.server.wallabag", serverController.server.text)
        XCTAssertTrue(analyticsMock.eventScreenView == AnalyticsManager.AnalyticsViewEvent.serverView)
    }

    func testWithInvalidUrlThenShowAlertError() {
        container.register(SettingMock.self) { _ in
            SettingMock()
        }.inObjectScope(.container)
        container.storyboardInitCompleted(ServerViewController.self) { r, c in
            c.analytics = r.resolve(AnalyticsManagerMock.self)
            c.setting = r.resolve(SettingMock.self)
        }
        serverController = (storyboard.instantiateViewController(withIdentifier: "ServerViewController") as! ServerViewController)
        UIApplication.shared.keyWindow?.rootViewController = serverController

        serverController.server.text = "invalidurl"
        serverController.nextButton.sendActions(for: .touchUpInside)

        XCTAssertTrue(serverController.presentedViewController is UIAlertController)
        XCTAssertEqual("invalidurl", container.resolve(SettingMock.self)?.settedValues["host"])
        XCTAssertEqual("Error", (serverController.presentedViewController as! UIAlertController).title)
        XCTAssertEqual("Whoops looks like something went wrong. Check the url, don't forget http or https", (serverController.presentedViewController as! UIAlertController).message)
    }

    func testWithValidUrlThenPerfomSegue() {
        container.register(SettingMock.self) { _ in
            SettingMock()
        }.inObjectScope(.container)
        container.storyboardInitCompleted(ServerViewController.self) { r, c in
            c.analytics = r.resolve(AnalyticsManagerMock.self)
            c.setting = r.resolve(SettingMock.self)
        }
        container.storyboardInitCompleted(ClientIdViewController.self) { r, c in
            c.analytics = r.resolve(AnalyticsManagerMock.self)
            c.setting = r.resolve(SettingMock.self)
        }
        serverController = (storyboard.instantiateViewController(withIdentifier: "ServerViewController") as! ServerViewController)
        UIApplication.shared.keyWindow?.rootViewController = serverController

        serverController.server.text = "http://isvalid.url"
        serverController.nextButton.sendActions(for: .touchUpInside)

        XCTAssertTrue(serverController.presentedViewController is ClientIdViewController)
        XCTAssertEqual("http://isvalid.url", container.resolve(SettingMock.self)?.settedValues["host"])
    }
}
