//
//  ServerViewControllerTests.swift
//  wallabagTests
//
//  Created by maxime marinel on 10/04/2019.
//

import XCTest
@testable import wallabag
import SwinjectStoryboard
import Swinject
import WallabagCommon

class ServerViewControllerTests: XCTestCase {
    class AnalyticsManagerMock: AnalyticsManagerProtocol {
        var sendScreenViewedCalled = false
        var event: AnalyticsManager.AnalyticsViewEvent?
        func sendScreenViewed(_ event: AnalyticsManager.AnalyticsViewEvent) {
            sendScreenViewedCalled = true
            self.event = event
        }
    }

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
        class SettingMock: SettingProtocol {
            func get<ValueType>(for key: SettingKey<ValueType>) -> ValueType {
                return ("http://my.server.wallabag" as? ValueType)!
            }
            func set<ValueType>(_ value: ValueType, for key: SettingKey<ValueType>) {}
        }
        container.register(SettingMock.self) { _ in
            return SettingMock()
        }
        container.storyboardInitCompleted(ServerViewController.self) { r, c in
            c.analytics = r.resolve(AnalyticsManagerMock.self)
            c.setting = r.resolve(SettingMock.self)
        }
        serverController = (storyboard.instantiateViewController(withIdentifier: "ServerViewController") as! ServerViewController)
        _ = serverController.view
        XCTAssertEqual("http://my.server.wallabag", serverController.server.text)
        XCTAssertTrue(analyticsMock.event == AnalyticsManager.AnalyticsViewEvent.serverView)
    }

    func testWithInvalidUrlThenShowAlertError() {
        class SettingMock: SettingProtocol {
            var setValue: String?
            func get<ValueType>(for key: SettingKey<ValueType>) -> ValueType {
                return ("" as? ValueType)!
            }
            func set<ValueType>(_ value: ValueType, for key: SettingKey<ValueType>) {
                print(value)
                setValue = (value as! String)
            }
        }
        container.register(SettingMock.self) { _ in
            return SettingMock()
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
        XCTAssertEqual("invalidurl", container.resolve(SettingMock.self)?.setValue)
        XCTAssertEqual("Error", (serverController.presentedViewController as! UIAlertController).title)
        XCTAssertEqual("Whoops looks like something went wrong. Check the url, don't forget http or https", (serverController.presentedViewController as! UIAlertController).message)
    }

    func testWithValidUrlThenPerfomSegue() {
        class SettingMock: SettingProtocol {
            var setValue: String?
            func get<ValueType>(for key: SettingKey<ValueType>) -> ValueType {
                return ("" as? ValueType)!
            }
            func set<ValueType>(_ value: ValueType, for key: SettingKey<ValueType>) {
                setValue = (value as! String)
            }
        }
        container.register(SettingMock.self) { _ in
            return SettingMock()
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
        XCTAssertEqual("http://isvalid.url", container.resolve(SettingMock.self)?.setValue)
    }
}
