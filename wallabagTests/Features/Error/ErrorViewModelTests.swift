@testable import wallabag
import XCTest

class ErrorViewModelTests: XCTestCase {
    func testError() throws {
        let errorPublisher = ErrorViewModel(1)
        XCTAssertNil(errorPublisher.lastError)

        errorPublisher.setLast(.syncError("Error test"))

        let exp = expectation(description: "test")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            exp.fulfill()
            XCTAssertNil(errorPublisher.lastError)
        }

        wait(for: [exp], timeout: 3)
    }
}
