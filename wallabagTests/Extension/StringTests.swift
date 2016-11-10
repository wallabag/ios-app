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
}
