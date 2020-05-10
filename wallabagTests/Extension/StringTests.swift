//
//  StringTests.swift
//  wallabag
//
//  Created by maxime marinel on 10/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

@testable import wallabag
import XCTest

class StringTests: XCTestCase {
    func testDateWithWrongFormatReturnNil() {
        XCTAssertNil("".date)
    }

    func testDateWithGoodFormatReturnDate() {
        let date = "2016-11-10T17:34:20+0100".date

        XCTAssertNotNil(date)

        let components = Calendar.current.dateComponents([.hour, .minute, .second, .day, .month, .year], from: date!)

        XCTAssertEqual(2016, components.year)
        XCTAssertEqual(11, components.month)
        XCTAssertEqual(10, components.day)
    }

    func testUcFirst() {
        let string = "test"

        XCTAssertEqual("Test", string.ucFirst)
    }

    func testLcFirst() {
        let string = "Test"

        XCTAssertEqual("test", string.lcFirst)
    }

    func testWithoutHTML() {
        XCTAssertEqual("hello world", "<p>hello world</p>".withoutHTML)
    }

    func testSpeakable() {
        let speakable = "<p>hello world</p><p>Second</p>".speakable
        XCTAssertEqual(2, speakable.count)
    }

    func testURL() {
        XCTAssertNil("".url)
        XCTAssertTrue("https://app.wallabag.it".url != nil)
    }

    func testIsValidURLFalse() {
        XCTAssertFalse("app".isValidURL)
        XCTAssertFalse("https://".isValidURL)
    }

    func testIsValidURL() {
        XCTAssertFalse("app".isValidURL)
        XCTAssertTrue("https://app.wallabag.it".isValidURL)
    }

    func testIsValidURLWithPort() {
        XCTAssertFalse("app".isValidURL)
        XCTAssertTrue("https://app.wallabag.it:9000".isValidURL)
    }

    func testMD5() {
        XCTAssertEqual("098f6bcd4621d373cade4e832627b4f6", "test".md5)
    }
}
