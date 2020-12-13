@testable import wallabag
import XCTest

class ClientIdSecretViewModelTests: XCTestCase {
    override func setUp() {
        WallabagUserDefaults.clientId = ""
        WallabagUserDefaults.clientSecret = ""
    }

    func testHandlerWithInvalidValue() throws {
        let handler = ClientIdSecretViewModel()

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
        let handler = ClientIdSecretViewModel()

        XCTAssertFalse(handler.isValid)

        handler.clientId = "test"
        handler.clientSecret = "aea"

        XCTAssertTrue(handler.isValid)
        XCTAssertEqual("test", WallabagUserDefaults.clientId)
        XCTAssertEqual("aea", WallabagUserDefaults.clientSecret)
    }

    func testDeinit() throws {
        class ClassUnderTest: ClientIdSecretViewModel {
            var deinitCalled: (() -> Void)?
            deinit { deinitCalled?() }
        }

        let exp = expectation(description: debugDescription)

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
