//
//  RegistrationClientIdSecretViewHandlerTests.swift
//  wallabagTests
//
//  Created by Marinel Maxime on 20/03/2020.
//

import XCTest
@testable import wallabag

class RegistrationClientIdSecretViewHandlerTests: XCTestCase {

    override func setUp() {
        WallabagUserDefaults.clientId = ""
        WallabagUserDefaults.clientSecret = ""
    }

    func testHandlerWithInvalidValue() throws {
        let handler = RegistrationClientIdSecretViewHandler()

        XCTAssertFalse(handler.isValid)

        handler.clientId = "test"

        XCTAssertFalse(handler.isValid)
        XCTAssertEqual("", WallabagUserDefaults.clientId)
        XCTAssertEqual("", WallabagUserDefaults.clientSecret)

        handler.clientId = ""
        handler.clientSecret = "aea"

        XCTAssertFalse(handler.isValid)
        XCTAssertEqual("", WallabagUserDefaults.clientId)
        XCTAssertEqual("", WallabagUserDefaults.clientSecret)
    }

    func testHandlerWithValidValue() throws {
        let handler = RegistrationClientIdSecretViewHandler()

        XCTAssertFalse(handler.isValid)

        handler.clientId = "test"
        handler.clientSecret = "aea"

        XCTAssertTrue(handler.isValid)
        XCTAssertEqual("test", WallabagUserDefaults.clientId)
        XCTAssertEqual("aea", WallabagUserDefaults.clientSecret)
    }

    func testDeinit() throws {
        class ClassUnderTest: RegistrationClientIdSecretViewHandler {
            var deinitCalled: (() -> Void)?
            deinit { deinitCalled?() }
        }

        let exp = expectation(description: self.debugDescription)

        var instance: ClassUnderTest? = ClassUnderTest()

        instance?.deinitCalled = {
            exp.fulfill()
        }

        DispatchQueue.global(qos: .background).async {
            instance = nil
        }

        waitForExpectations(timeout: 10)
    }
}
