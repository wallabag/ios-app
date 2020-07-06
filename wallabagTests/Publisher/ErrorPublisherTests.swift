//
//  ErrorPublisherTests.swift
//  wallabagTests
//
//  Created by Marinel Maxime on 20/04/2020.
//

@testable import wallabag
import XCTest

class ErrorPublisherTests: XCTestCase {
    func testError() throws {
        let errorPublisher = ErrorPublisher(1)
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
