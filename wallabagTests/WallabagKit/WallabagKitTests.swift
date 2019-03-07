//
//  WallabagKitTests.swift
//  wallabagTests
//
//  Created by maxime marinel on 01/06/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Mockingjay
@testable import wallabag
@testable import WallabagKit
import XCTest

class WallabagKitTests: XCTestCase {
    func testAuthWithEmptyParameterThenInvalidParameter() {
        let expectation = XCTestExpectation(description: "wait login")
        let kit = WallabagKit()

        kit.requestAuth(username: "John", password: "dodo") { completion in
            if case .invalidParameter = completion {
                XCTAssertTrue(true)
            } else {
                XCTFail("invalidParameter not returned")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testAuthWithRequiredParameterButInvalidResponseThenUnexpectedError() {
        stub(uri("http://localhost/oauth/v2/token"), json(["test": "toto"]))

        let expectation = XCTestExpectation(description: "wait login")
        let kit = WallabagKit(host: "http://localhost", clientID: "myId", clientSecret: "mySecret")

        kit.requestAuth(username: "John", password: "dodo") { completion in
            if case .unexpectedError = completion {
                XCTAssertTrue(true)
            } else {
                XCTFail("unexpectedError not returned")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testAuthRequiredParameterValidResponse() {
        let path = Bundle(for: type(of: self)).url(forResource: "AuthSuccess", withExtension: "json")!
        let data = try! Data(contentsOf: path)

        stub({ request in
            // TODO: need to find how to check post parameter
            request.httpMethod == HTTPMethod.post.description
                && request.url?.absoluteString == "http://localhost/oauth/v2/token"
        }, jsonData(data))

        let expectation = XCTestExpectation(description: "wait login")
        let kit = WallabagKit(host: "http://localhost", clientID: "myId", clientSecret: "mySecret")

        XCTAssertNil(kit.accessToken)

        kit.requestAuth(username: "John", password: "dodo") { completion in
            switch completion {
            case let .success(success):
                XCTAssertEqual("MjQyYjk4OWNmODA2ZGZiZTJiNjFiN2I2ZmQ3YTcwODFjYjBiODcwMWFlNmZjNGQ0ZDRkYjgwMTNjMDQyZGUwYQ", success.accessToken)
                XCTAssertEqual(success.accessToken, kit.accessToken)
            default:
                XCTFail("success not returned")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testAuthWrongPasswordResponse() {
        let path = Bundle(for: type(of: self)).url(forResource: "AuthWrongPassword", withExtension: "json")!
        let data = try! Data(contentsOf: path)

        stub({ request in
            // TODO: need to find how to check post parameter
            request.httpMethod == HTTPMethod.post.description
                && request.url?.absoluteString == "http://localhost/oauth/v2/token"
        }, http(400, headers: nil, download: .content(data)))

        let expectation = XCTestExpectation(description: "wait login")
        let kit = WallabagKit(host: "http://localhost", clientID: "myId", clientSecret: "mySecret")

        kit.requestAuth(username: "John", password: "wrongPassword") { completion in
            switch completion {
            case let .error(error):
                XCTAssertEqual("invalid_grant", error.error)
                XCTAssertEqual("Invalid username and password combination", error.description)
            default:
                XCTFail("error not returned")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
