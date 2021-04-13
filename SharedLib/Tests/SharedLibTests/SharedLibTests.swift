@testable import SharedLib
import XCTest

final class SharedLibTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SharedLib().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
