//
//  BoolTests.swift
//  wallabagTests
//
//  Created by maxime marinel on 08/04/2019.
//
@testable import wallabag
import XCTest

class BoolTests: XCTestCase {
    func testInt() {
        XCTAssertEqual(1, true.int)
        XCTAssertEqual(0, false.int)
    }
}
