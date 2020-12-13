@testable import wallabag
import XCTest

class BoolTests: XCTestCase {
    func testTrue() {
        XCTAssertEqual(1, true.int)
    }

    func testFalse() {
        XCTAssertEqual(0, false.int)
    }
}
