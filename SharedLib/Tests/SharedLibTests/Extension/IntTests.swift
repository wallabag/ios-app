import XCTest

class IntTests: XCTestCase {
    func testReadingTime() {
        // Basic minute tests
        XCTAssertEqual("00:01:00", 1.readingTime)
        XCTAssertEqual("00:02:00", 2.readingTime)
        XCTAssertEqual("00:05:00", 5.readingTime)
        XCTAssertEqual("00:10:00", 10.readingTime)
        XCTAssertEqual("00:30:00", 30.readingTime)
        XCTAssertEqual("00:45:00", 45.readingTime)

        // Hour boundary tests
        XCTAssertEqual("01:00:00", 60.readingTime)
        XCTAssertEqual("01:01:00", 61.readingTime)
        XCTAssertEqual("01:30:00", 90.readingTime)

        // Multiple hours
        XCTAssertEqual("02:00:00", 120.readingTime)
        XCTAssertEqual("02:15:00", 135.readingTime)
        XCTAssertEqual("03:45:00", 225.readingTime)

        // Edge cases
        XCTAssertEqual("00:00:00", 0.readingTime)

        // Long reading times
        XCTAssertEqual("10:00:00", 600.readingTime)
        XCTAssertEqual("24:00:00", 1440.readingTime)
    }

    func testBool() {
        XCTAssertFalse(0.bool)
        XCTAssertTrue(1.bool)
        XCTAssertFalse(2.bool)
    }
}
