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
    class ThemeManagerMock: ThemeManagerProtocol {
        func getBackgroundColor() -> UIColor {
            return UIColor.red
        }
    }

    var bundle: Bundle = Bundle(identifier: "fr.district-web.wallabag")!
    var aboutController: AboutViewController!
    var analyticsMock: AnalyticsManagerMock = AnalyticsManagerMock()
    var themeManagerMock: ThemeManagerMock = ThemeManagerMock()

    override func setUp() {
        let container = Container()
        container.register(AnalyticsManagerMock.self) { _ in self.analyticsMock }
        container.register(ThemeManagerMock.self) { _ in self.themeManagerMock }

        let storyboard = SwinjectStoryboard.create(name: "About", bundle: bundle, container: container)
        container.storyboardInitCompleted(AboutViewController.self) { r, c in
            c.analytics = r.resolve(AnalyticsManagerMock.self)
            c.themeManager = r.resolve(ThemeManagerMock.self)
        }
        aboutController = (storyboard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController)
        _ = aboutController.view
    }

    func testLoadController() {
        XCTAssertTrue(analyticsMock.sendScreenViewedCalled)
        XCTAssertTrue(analyticsMock.eventScreenView == AnalyticsManager.AnalyticsViewEvent.aboutView)
        XCTAssertEqual(String(format: "Version %@ build %@".localized, arguments: [bundle.infoDictionary!["CFBundleShortVersionString"] as! CVarArg, bundle.infoDictionary!["CFBundleVersion"] as! CVarArg]), aboutController.versionText.text)
        XCTAssertEqual(UIColor.red, aboutController.view.backgroundColor)
    }
}
