//
//  RegistrationLoginViewHandlerTests.swift
//  wallabagTests
//
//  Created by Marinel Maxime on 20/03/2020.
//

import XCTest
@testable import wallabag

class RegistrationLoginViewHandlerTests: XCTestCase {

    override func setUp() {
        WallabagUserDefaults.login = ""
        WallabagUserDefaults.password = ""
    }

    func testHandlerWithInvalidValue() {
        let handler = RegistrationLoginViewHandler()

        XCTAssertFalse(handler.isValid)

        handler.login = "login"
        XCTAssertFalse(handler.isValid)

        handler.login = ""
        handler.password = "pwd"

        XCTAssertFalse(handler.isValid)
    }

    func testHandlerWithValidValue() {
        let handler = RegistrationLoginViewHandler()

        XCTAssertFalse(handler.isValid)
        handler.login = "login"
        handler.password = "pwd"

        XCTAssertTrue(handler.isValid)
    }

    func testTryLogin() {
        let handler = RegistrationLoginViewHandler()

        XCTAssertEqual("", WallabagUserDefaults.login)
        XCTAssertEqual("", WallabagUserDefaults.password)
        handler.login = "log"
        handler.password = "pwd"

        handler.tryLogin()

        XCTAssertEqual("log", WallabagUserDefaults.login)
        XCTAssertEqual("pwd", WallabagUserDefaults.password)
    }
    /*
     func testHandlerObserveState() {
     let handler = RegistrationLoginViewHandler()

     let cancelExpectation = expectation(description: "Cancel")

     XCTAssertFalse(handler.appState.registred)

     XCTAssertNil(handler.error)

     handler.appState.session.state = .error(reason: "error test")

     XCTAssertEqual("error test", handler.error!)

     let appState = handler.appState


     handler.appState.session.state = .connected
     let cancellable = appState.$registred.sink { value in
     XCTAssertTrue(value)
     cancelExpectation.fulfill()
     }

     wait(for: [cancelExpectation], timeout: 5.0)
     cancellable.cancel()

     }
     */
    func testDeinit() throws {
        class ClassUnderTest: RegistrationLoginViewHandler {
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
