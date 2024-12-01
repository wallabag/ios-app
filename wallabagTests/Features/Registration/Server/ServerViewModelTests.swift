import Combine
import SharedLib
@testable import wallabag
import XCTest

final class ServerViewModelTests: XCTestCase {
    var cancellable = Set<AnyCancellable>()

    override func setUp() {
        WallabagUserDefaults.host = ""
    }

    func testInit() {
        let model = ServerViewModel()

        XCTAssertEqual("", model.url)
    }

    func testInvalidUrl() {
        let model = ServerViewModel()

        XCTAssertEqual("", model.url)
        XCTAssertFalse(model.isValid)

        model.url = "azerty"
        XCTAssertEqual("", WallabagUserDefaults.host)
        XCTAssertFalse(model.isValid)
    }

    func testValidUrl() {
        let model = ServerViewModel()

        XCTAssertEqual("", model.url)
        XCTAssertEqual("", WallabagUserDefaults.host)
        XCTAssertFalse(model.isValid)

        model.url = "https://wallabag.it"

        XCTAssertEqual("", WallabagUserDefaults.host)
        XCTAssertTrue(model.isValid)
    }

    func testUpdateHostOnGoNext() {
        let model = ServerViewModel()

        XCTAssertEqual("", model.url)
        XCTAssertEqual("", WallabagUserDefaults.host)
        XCTAssertFalse(model.isValid)
        model.url = "https://wallabag.it"
        XCTAssertEqual("", WallabagUserDefaults.host)

        model.goNext()
        XCTAssertEqual("https://wallabag.it", WallabagUserDefaults.host)
    }
}
