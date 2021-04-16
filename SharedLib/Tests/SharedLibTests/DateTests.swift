import XCTest

class DateTests: XCTestCase {
    func testDateFromIsoString() {
        let date = Date.fromISOString("1977-04-22T01:00:00-05:00")
        #warning("Add better test")
        XCTAssertTrue(nil != date)
    }
}
