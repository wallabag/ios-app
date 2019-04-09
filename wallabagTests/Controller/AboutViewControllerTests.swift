//
//  AboutViewControllerTests.swift
//  wallabagTests
//
//  Created by maxime marinel on 09/04/2019.
//

import Swinject
import SwinjectStoryboard
@testable import wallabag
import XCTest

class AboutViewControllerTests: XCTestCase {
    class AnalyticsManagerMock: AnalyticsManagerProtocol {
        var sendScreenViewedCalled = false
        var event: AnalyticsManager.AnalyticsViewEvent?
        func sendScreenViewed(_ event: AnalyticsManager.AnalyticsViewEvent) {
            sendScreenViewedCalled = true
            self.event = event
        }
    }

    var aboutController: AboutViewController!
    var analyticsMock: AnalyticsManagerMock = AnalyticsManagerMock()

    override func setUp() {
        let container = Container()
        container.register(AnalyticsManagerMock.self) { _ in self.analyticsMock }
        container.register(ThemeManager.self) { _ in ThemeManager(currentTheme: Black()) }

        let storyboard = SwinjectStoryboard.create(name: "About", bundle: Bundle(identifier: "fr.district-web.wallabag"), container: container)
        container.storyboardInitCompleted(AboutViewController.self) { r, c in
            c.analytics = r.resolve(AnalyticsManagerMock.self)
            c.themeManager = r.resolve(ThemeManager.self)
        }
        aboutController = (storyboard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController)
        _ = aboutController.view
    }

    func testLoadController() {
        XCTAssertTrue(analyticsMock.sendScreenViewedCalled)
        XCTAssertTrue(analyticsMock.event == AnalyticsManager.AnalyticsViewEvent.aboutView)
    }
}
