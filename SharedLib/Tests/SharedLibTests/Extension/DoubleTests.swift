import XCTest

class DoubleTests: XCTestCase {
    func testReadingTime() {
        // Basic minute tests
        XCTAssertEqual("00:01:00", 1.0.readingTime)
        XCTAssertEqual("00:02:00", 2.0.readingTime)
        XCTAssertEqual("00:05:00", 5.0.readingTime)
        XCTAssertEqual("00:10:00", 10.0.readingTime)
        XCTAssertEqual("00:30:00", 30.0.readingTime)
        XCTAssertEqual("00:45:00", 45.0.readingTime)

        // Hour boundary tests
        XCTAssertEqual("01:00:00", 60.0.readingTime)
        XCTAssertEqual("01:01:00", 61.0.readingTime)
        XCTAssertEqual("01:30:00", 90.0.readingTime)

        // Multiple hours
        XCTAssertEqual("02:00:00", 120.0.readingTime)
        XCTAssertEqual("02:15:00", 135.0.readingTime)
        XCTAssertEqual("03:45:00", 225.0.readingTime)

        // Fractional minutes (should truncate seconds properly)
        XCTAssertEqual("00:01:30", 1.5.readingTime)
        XCTAssertEqual("00:02:15", 2.25.readingTime)
        XCTAssertEqual("00:05:45", 5.75.readingTime)

        // Edge cases
        XCTAssertEqual("00:00:00", 0.0.readingTime)

        // Long reading times
        XCTAssertEqual("10:00:00", 600.0.readingTime)
        XCTAssertEqual("24:00:00", 1440.0.readingTime)
    }
}
