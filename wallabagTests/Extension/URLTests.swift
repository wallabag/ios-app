@testable import wallabag
import XCTest

class URLTests: XCTestCase {
    func testStringLiteral() throws {
        let url: URL = "https://github.com/wallabag"
        XCTAssertEqual("https://github.com/wallabag", url.absoluteString)
    }
}
