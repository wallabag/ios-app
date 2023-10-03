import Combine
import SharedLib
@testable import wallabag
import XCTest

final class ServerViewModelTests: XCTestCase {
    var cancellable = Set<AnyCancellable>()

    override class func setUp() {
        WallabagUserDefaults.host = ""
    }

    func testInit() {
        let model = ServerViewModel()

        XCTAssertEqual("", model.url)
    }

    func testInvalidUrl() {
        let model = ServerViewModel()

        let expectation = XCTestExpectation(description: "Invalid url")

        XCTAssertEqual("", model.url)
        XCTAssertFalse(model.isValid)

        model.$isValid
            .dropFirst()
            .sink(receiveValue: {
                XCTAssertFalse($0)
                expectation.fulfill()
            })
            .store(in: &cancellable)

        model.url = "azerty"
        XCTAssertEqual("", WallabagUserDefaults.host)

        wait(for: [expectation], timeout: 1)
    }

    func testValidUrl() {
        let model = ServerViewModel()

        let expectation = XCTestExpectation(description: "Valid url")

        XCTAssertEqual("", model.url)
        XCTAssertEqual("", WallabagUserDefaults.host)
        XCTAssertFalse(model.isValid)

        model.$isValid
            .dropFirst()
            .sink(receiveValue: {
                XCTAssertTrue($0)
                expectation.fulfill()
            })
            .store(in: &cancellable)
        model.url = "https://wallabag.it"

        XCTAssertEqual("https://wallabag.it", WallabagUserDefaults.host)

        wait(for: [expectation], timeout: 1)
    }
}
