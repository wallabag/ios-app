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

    override func setUp() {
        storyboard = SwinjectStoryboard.create(name: "Article", bundle: bundle, container: container)
        podcastController = (storyboard.instantiateViewController(withIdentifier: "PodcastViewController") as! PodcastViewController)
    }

    func testCrashAnAVSpeechUtteranceShallNotBeEnqueuedTwice() {
        let mock = Entry()
        mock.content = "test<br/>test"
        podcastController.entry = mock

        UIApplication.shared.keyWindow?.rootViewController = podcastController

        podcastController.playButton.sendActions(for: .touchUpInside)
        podcastController.playButton.sendActions(for: .touchUpInside)
    }
}
