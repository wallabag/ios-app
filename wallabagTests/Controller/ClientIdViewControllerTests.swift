//
//  ClientIdViewControllerTests.swift
//  wallabagTests
//
//  Created by maxime marinel on 13/04/2019.
//

import Swinject
import SwinjectStoryboard
@testable import wallabag
import WallabagCommon
import XCTest

class ClientIdViewControllerTests: XCTestCase {
    let container = Container()
    var storyboard: SwinjectStoryboard!
    var bundle: Bundle = Bundle(identifier: "fr.district-web.wallabag")!
    var analyticsMock: AnalyticsManagerMock = AnalyticsManagerMock()
    var clientIdController: ClientIdViewController!

    override func setUp() {
        storyboard = SwinjectStoryboard.create(name: "Registration", bundle: bundle, container: container)
        container.register(AnalyticsManagerMock.self) { _ in self.analyticsMock }
    }

    func testWithSettingFillFields() {
        class SettingMock: SettingProtocol {
            func get<ValueType>(for test: SettingKey<ValueType>) -> ValueType {
                if "clientId" == test.key {
                    return ("the_client_id" as? ValueType)!
                }
                if "clientSecret" == test.key {
                    return ("the_client_secret" as? ValueType)!
                }
                fatalError()
            }

            func set<ValueType>(_: ValueType, for _: SettingKey<ValueType>) {}
            func set(password: String, username: String) {}
        }
        container.register(SettingMock.self) { _ in
            SettingMock()
        }
        container.storyboardInitCompleted(ClientIdViewController.self) { r, c in
            c.analytics = r.resolve(AnalyticsManagerMock.self)
            c.setting = r.resolve(SettingMock.self)
        }
        clientIdController = (storyboard.instantiateViewController(withIdentifier: "ClientIdViewController") as! ClientIdViewController)
        _ = clientIdController.view

        XCTAssertTrue(analyticsMock.eventScreenView == AnalyticsManager.AnalyticsViewEvent.clientIdView)
        XCTAssertEqual("the_client_id", clientIdController.clientId.text)
        XCTAssertEqual("the_client_secret", clientIdController.clientSecret.text)
    }

    func testFillFieldAndNextButtonPressedThenSetSettings() {
        class SettingMock: SettingProtocol {
            var settedValues: [String:String] = [:]
            func get<ValueType>(for test: SettingKey<ValueType>) -> ValueType {
                return ("" as? ValueType)!
            }

            func set<ValueType>(_ value: ValueType, for key: SettingKey<ValueType>) {
                print(key.key)
                print(value)
                settedValues[key.key] = (value as! String)
            }
            func set(password: String, username: String) {}
        }
        container.register(SettingMock.self) { _ in
            SettingMock()
        }.inObjectScope(.container)
        container.storyboardInitCompleted(ClientIdViewController.self) { r, c in
            c.analytics = r.resolve(AnalyticsManagerMock.self)
            c.setting = r.resolve(SettingMock.self)
        }
        container.storyboardInitCompleted(LoginViewController.self) { r, c in
            c.analytics = r.resolve(AnalyticsManagerMock.self)
            c.setting = r.resolve(SettingMock.self)
        }
        clientIdController = (storyboard.instantiateViewController(withIdentifier: "ClientIdViewController") as! ClientIdViewController)
        UIApplication.shared.keyWindow?.rootViewController = clientIdController

        clientIdController.clientId.text = "the_tested_client_id"
        clientIdController.clientSecret.text = "the_tested_client_secret"
        clientIdController.nextButton.sendActions(for: .touchUpInside)

        XCTAssertEqual("the_tested_client_id", container.resolve(SettingMock.self)!.settedValues["clientId"])
        XCTAssertEqual("the_tested_client_secret", container.resolve(SettingMock.self)!.settedValues["clientSecret"])
    }
}
