@testable import wallabag
import XCTest

class ServerViewModelTests: XCTestCase {
    override func setUp() {
        WallabagUserDefaults.host = ""
    }

    func testHandlerWithInvalidURL() throws {
        let handler = ServerViewModel()
        XCTAssertFalse(handler.isValid)
        handler.url = "app.wallabag.it"
        XCTAssertFalse(handler.isValid)
        XCTAssertEqual("", WallabagUserDefaults.host)
    }

    func testHandlerWithValidURL() throws {
        let handler = ServerViewModel()
        XCTAssertFalse(handler.isValid)
        handler.url = "https://app.wallabag.it"
        XCTAssertTrue(handler.isValid)
        XCTAssertEqual("https://app.wallabag.it", WallabagUserDefaults.host)
    }

    func testDeinit() throws {
        class ClassUnderTest: ServerViewModel {
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
