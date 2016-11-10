//
//  IntTests.swift
//  wallabag
//
//  Created by maxime marinel on 10/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import XCTest
@testable import wallabag

class IntTests: XCTestCase {

    func testReadingTime() {
        XCTAssertEqual("01:00", 1.readingTime)
        XCTAssertEqual("02:00", 2.readingTime)
    }
}
