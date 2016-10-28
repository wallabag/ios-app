//
//  WallabagApiTests.swift
//  wallabag
//
//  Created by maxime marinel on 28/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import XCTest
@testable import wallabag

class WallabagApiTests: XCTestCase {

    override func setUp() {
        super.setUp()

        WallabagApi.configureApi(endpoint: "http://v2.wallabag.org", clientId: "102_1k82ulkibxdwoccgs0cgoowgg0c04wsc8k08kcc0ksk80skcsg", clientSecret: "5honlishnu8s4s0k4wg4kokg4kkw84kwww4ock8ko4wcw4okk0", username: "wallabag", password: "wallabag")
    }

    override func tearDown() {
        super.tearDown()
    }

    func testRequestTokenOnValidEndpoint() {
        let expectation = self.expectation(description: "testRequestTokenOnValidEndpoint")

        WallabagApi.requestToken { success in
            XCTAssertTrue(success)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testRetrieveArticles() {
        let expectation = self.expectation(description: "testRetrieveArticles")

        WallabagApi.retrieveArticle { articles in
            XCTAssertTrue(0 != articles.count)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

}
