//
//  IntTests.swift
//  wallabag
//
//  Created by maxime marinel on 10/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

@testable import wallabag
import XCTest

class IntTests: XCTestCase {
    func testReadingTime() {
        XCTAssertEqual("00:01:00", 1.readingTime)
        XCTAssertEqual("00:02:00", 2.readingTime)
        XCTAssertEqual("01:01:00", 61.readingTime)
    }

    func testRgb() {
        XCTAssertEqual(1, 255.rgb)
    }

    func testBool() {
        XCTAssertFalse(0.bool)
        XCTAssertTrue(1.bool)
        XCTAssertFalse(2.bool)
    }
}
