//
//  WallabagApiTests.swift
//  wallabag
//
//  Created by maxime marinel on 28/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import XCTest
@testable import wallabag

//@todo rework API
class WallabagApiTests: XCTestCase {

    override func setUp() {
        super.setUp()

        WallabagApi.configureApi(endpoint: "http://wallabag.maxime.marinel.me", clientId: "2_2vw9bl00nn6sk4skscc408wswk80gscg8o88swsw8ow4wkgccs", clientSecret: "30vyapj31jgg4cgw8s00k0go4cc0osgk0048cwooow4cc8o004", username: "dev", password: "dev")
    }

    override func tearDown() {
        super.tearDown()
    }
    /*
     func testRequestTokenOnValidEndpoint() {
     let expectation = self.expectation(description: "testRequestTokenOnValidEndpoint")
     WallabagApi.requestToken { success in
     XCTAssertTrue(success)
     expectation.fulfill()
     }

     waitForExpectations(timeout: 10, handler: nil)
     }

     func testRequestTokenOnWithInvalidToken() {
     WallabagApi.configureApi(endpoint: "http://wallabag.maxime.marinel.me", clientId: "1_19ayjxe551eswc4gc0sggcc88oks8k04004404kkw84osk8s4k", clientSecret: "invalid", username: "wallabag", password: "wallabag")

     let expectation = self.expectation(description: "testRequestTokenOnWithInvalidToken")
     WallabagApi.requestToken { result in
     XCTAssertFalse(result)
     expectation.fulfill()
     }

     waitForExpectations(timeout: 10, handler: nil)
     }

     func testRequestTokenOnWithInvalidEndpoint() {
     WallabagApi.configureApi(endpoint: "http://wallaaeaeaxbag.maxime.marinel.me", clientId: "1_19ayjxe551eswc4gc0sggcc88oks8k04004404kkw84osk8s4k", clientSecret: "invalid", username: "wallabag", password: "wallabag")

     let expectation = self.expectation(description: "testRequestTokenOnWithInvalidEndpoint")
     WallabagApi.requestToken { result in
     XCTAssertFalse(result)
     expectation.fulfill()
     }

     waitForExpectations(timeout: 10, handler: nil)
     }

     func testRetrieveArticles() {
     let expectation = self.expectation(description: "testRetrieveArticles")

     WallabagApi.retrieveArticle { articles in
     XCTAssertTrue(0 != articles.count)
     XCTAssertTrue(20 == articles.count)
     expectation.fulfill()
     }

     waitForExpectations(timeout: 10, handler: nil)
     }
     */
}
