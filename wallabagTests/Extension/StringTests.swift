//
//  StringTests.swift
//  wallabag
//
//  Created by maxime marinel on 10/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import XCTest
@testable import wallabag

class StringTests: XCTestCase {

    func testDateWithWrongFormatReturnNil() {
        XCTAssertNil("".date)
    }

    func testDateWithGoodFormatReturnDate() {
    	let date = "2016-11-10T17:34:20+0100".date

    	let components = Calendar.current.dateComponents([.hour, .minut, .second, .day, .month, .year], from: date)

        XCTAssertNotNil(date)
        XCTAssertEqual(2016, components.year)
        XCTAssertEqual(11, components.month)
        XCTAssertEqual(10, components.day)
        XCTAssertEqual(17, components.hour)
        XCTAssertEqual(34, components.minut)
        XCTAssertEqual(20, components.second)
    }
}
