@testable import wallabag
import XCTest

class RouterTests: XCTestCase {
    func testLoadRoute() throws {
        let router = Router()

        XCTAssertEqual(0, router.path.count)
    }
}
