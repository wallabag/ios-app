//
//  wallabagTests
//
//  Created by Marinel Maxime on 19/03/2020.
//

import XCTest
@testable import wallabag

class RegistrationServerViewHandlerTests: XCTestCase {

    override func setUp() {
        WallabagUserDefaults.host = ""
    }

    func testHandlerWithInvalidURL() throws {
        let handler = RegistrationServerViewHandler()
        XCTAssertFalse(handler.isValid)
        handler.url = "app.wallabag.it"
        XCTAssertFalse(handler.isValid)
        XCTAssertEqual("", WallabagUserDefaults.host)
    }

    func testHandlerWithValidURL() throws {
        let handler = RegistrationServerViewHandler()
        XCTAssertFalse(handler.isValid)
        handler.url = "https://app.wallabag.it"
        XCTAssertTrue(handler.isValid)
        XCTAssertEqual("https://app.wallabag.it", WallabagUserDefaults.host)
    }

    func testDeinit() throws {
        class ClassUnderTest: RegistrationServerViewHandler {
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
