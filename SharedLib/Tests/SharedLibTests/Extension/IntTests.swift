import XCTest

class IntTests: XCTestCase {
    func testReadingTime() {
        XCTAssertEqual("00:01:00", 1.readingTime)
        XCTAssertEqual("00:02:00", 2.readingTime)
        XCTAssertEqual("01:01:00", 61.readingTime)
    }

    func testBool() {
        XCTAssertFalse(0.bool)
        XCTAssertTrue(1.bool)
        XCTAssertFalse(2.bool)
    }
}
