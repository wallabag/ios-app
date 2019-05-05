//
//  ArticleViewController.swift
//  wallabagTests
//
//  Created by maxime marinel on 16/04/2019.
//

import RealmSwift
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
    var entry: Entry {
        let entry = Entry()
        entry.title = "The big title"
        entry.url = "http://url.of.myarticle"

        return entry
    }

    override func setUp() {
        storyboard = SwinjectStoryboard.create(name: "Article", bundle: bundle, container: container)
        container.register(AnalyticsManagerMock.self) { _ in self.analyticsMock }
        container.register(ThemeManagerMock.self) { _ in self.themeManagerMock }
        container.register(SettingMock.self) { _ in SettingMock(["justifyArticle": true]) }.inObjectScope(.container)
        container.register(Realm.self) { _ in
            do {
                return try Realm()
            } catch {
                fatalError("Error init realm")
            }
        }
        container.storyboardInitCompleted(ArticleViewController.self) { r, c in
            c.analytics = r.resolve(AnalyticsManagerMock.self)
            c.themeManager = r.resolve(ThemeManagerMock.self)
            c.setting = r.resolve(SettingMock.self)
            c.realm = r.resolve(Realm.self)
        }
        articleController = (storyboard.instantiateViewController(withIdentifier: "ArticleViewController") as! ArticleViewController)
    }

    func testViewDidLoad() {
        articleController.entry = entry
        UIApplication.shared.keyWindow?.rootViewController = articleController
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

    func testShareMenu() {
        articleController.entry = entry
        UIApplication.shared.keyWindow?.rootViewController = articleController

        articleController.shareMenu(UIBarButtonItem())

        XCTAssertEqual(AnalyticsManager.AnalyticsEvent.shareArticle.name, analyticsMock.event?.name)
        #warning("missing presented shareview")
    }

    func testAdd() {
        articleController.entry = entry
        UIApplication.shared.keyWindow?.rootViewController = articleController

        var addHandlerCalled = false
        articleController.addHandler = {
            addHandlerCalled = true
        }

        articleController.add(UIButton())
        XCTAssertTrue(addHandlerCalled)
    }

    func testRead() {
        let entry = self.entry
        articleController.entry = entry
        UIApplication.shared.keyWindow?.rootViewController = articleController

        var readHandlerCalled = false
        var entryHandler: Entry?
        articleController.readHandler = { entry in
            readHandlerCalled = true
            entryHandler = entry
        }

        articleController.read(UIButton())
        XCTAssertTrue(readHandlerCalled)
        XCTAssertEqual(entry, entryHandler)
    }

    func testStar() {
        let entry = self.entry
        articleController.entry = entry
        UIApplication.shared.keyWindow?.rootViewController = articleController

        var starHandlerCalled = false
        var entryHandler: Entry?
        articleController.starHandler = { entry in
            starHandlerCalled = true
            entryHandler = entry
        }

        articleController.star(UIButton())
        XCTAssertTrue(starHandlerCalled)
        XCTAssertEqual(entry, entryHandler)
    }

    func testDeleteArticleCancel() {
        let entry = self.entry
        articleController.entry = entry
        UIApplication.shared.keyWindow?.rootViewController = articleController

        articleController.deleteArticle(UIBarButtonItem())

        let alert: UIAlertController = articleController.presentedViewController as! UIAlertController
        XCTAssertEqual("Cancel", alert.actions.last!.title)
        // XCTAssertTrue(articleController.presentedViewController is UIAlertController)
    }
}
