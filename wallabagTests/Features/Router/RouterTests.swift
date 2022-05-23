@testable import wallabag
import XCTest

class RouterTests: XCTestCase {
    func testLoadRoute() throws {
        let router = Router(defaultRoute: .registration)

        XCTAssertEqual(.registration, router.route)

        router.load(.about)

        XCTAssertEqual(.about, router.route)
    }
}
