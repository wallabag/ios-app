//
//  PodcastViewControllerTests.swift
//  wallabagTests
//
//  Created by maxime marinel on 12/04/2019.
//

import Swinject
import SwinjectStoryboard
@testable import wallabag
import XCTest

class PodcastViewControllerTests: XCTestCase {
    let container = Container()
    var storyboard: SwinjectStoryboard!
    var bundle: Bundle = Bundle(identifier: "fr.district-web.wallabag")!
    var podcastController: PodcastViewController!
    var analyticsMock: AnalyticsManagerMock = AnalyticsManagerMock()

    override func setUp() {
        storyboard = SwinjectStoryboard.create(name: "Article", bundle: bundle, container: container)
        container.register(AnalyticsManagerMock.self) { _ in self.analyticsMock }
        container.storyboardInitCompleted(PodcastViewController.self) { r, c in
            c.analytics = r.resolve(AnalyticsManagerMock.self)
        }
        podcastController = (storyboard.instantiateViewController(withIdentifier: "PodcastViewController") as! PodcastViewController)
    }

    func testCrashAnAVSpeechUtteranceShallNotBeEnqueuedTwice() {
        let mock = Entry()
        mock.content = "test<br/>test"
        podcastController.entry = mock

        UIApplication.shared.keyWindow?.rootViewController = podcastController

        podcastController.playButton.sendActions(for: .touchUpInside)
        podcastController.playButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(analyticsMock.event?.value == AnalyticsManager.AnalyticsEvent.synthesis(state: true).value)
    }
}
