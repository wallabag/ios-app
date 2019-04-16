//
//  ArticleViewController.swift
//  wallabagTests
//
//  Created by maxime marinel on 16/04/2019.
//

import Swinject
import SwinjectStoryboard
@testable import wallabag
import XCTest

class ArticleViewControllerTests: XCTestCase {
    class ThemeManagerMock: ThemeManagerProtocol {
        func getBackgroundColor() -> UIColor {
            return UIColor.red
        }
    }

    let container = Container()
    var storyboard: SwinjectStoryboard!
    var bundle: Bundle = Bundle(identifier: "fr.district-web.wallabag")!
    var analyticsMock: AnalyticsManagerMock = AnalyticsManagerMock()
    var themeManagerMock: ThemeManagerMock = ThemeManagerMock()
    var articleController: ArticleViewController!

    override func setUp() {
        storyboard = SwinjectStoryboard.create(name: "Article", bundle: bundle, container: container)
        container.register(AnalyticsManagerMock.self) { _ in self.analyticsMock }
        container.register(ThemeManagerMock.self) { _ in self.themeManagerMock }
    }

    func testViewDidLoad() {
        container.storyboardInitCompleted(ArticleViewController.self) { r, c in
            c.analytics = r.resolve(AnalyticsManagerMock.self)
            c.themeManager = r.resolve(ThemeManagerMock.self)
        }
        articleController = (storyboard.instantiateViewController(withIdentifier: "ArticleViewController") as! ArticleViewController)
        let entry = Entry()
        entry.title = "The big title"
        articleController.entry = entry
        XCTAssertFalse(UIApplication.shared.isIdleTimerDisabled)
        UIApplication.shared.keyWindow?.rootViewController = articleController
        XCTAssertTrue(UIApplication.shared.isIdleTimerDisabled)
        XCTAssertEqual(AnalyticsManager.AnalyticsViewEvent.articleView, analyticsMock.eventScreenView)
        XCTAssertEqual("The big title", articleController.navigationItem.title)
        XCTAssertEqual("Read", articleController.readButton.accessibilityLabel)
        XCTAssertEqual("Star", articleController.starButton.accessibilityLabel)
        XCTAssertEqual("Speech", articleController.speechButton.accessibilityLabel)
        XCTAssertEqual("Delete", articleController.deleteButton.accessibilityLabel)
        XCTAssertEqual(.red, articleController.contentWeb.backgroundColor)
        XCTAssertEqual(.never, articleController.navigationItem.largeTitleDisplayMode)
        #warning("Missing test for webview:load")
    }
}
