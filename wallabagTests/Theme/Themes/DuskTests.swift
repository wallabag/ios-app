//
//  DuskTests.swift
//  wallabagTests
//
//  Created by maxime marinel on 24/04/2019.
//

@testable import wallabag
import XCTest

class DuskTests: XCTestCase {
    func testDuskTheme() {
        let theme = Dusk()
        XCTAssertEqual("dusk", theme.name)
        XCTAssertEqual("UIExtendedSRGBColorSpace 0.627451 0.627451 0.627451 1", theme.color.description)
        XCTAssertEqual(.default, theme.barStyle)
        XCTAssertEqual("UIExtendedSRGBColorSpace 0.627451 0.627451 0.627451 1", theme.tintColor.description)
        XCTAssertEqual("UIExtendedSRGBColorSpace 0.235294 0.235294 0.235294 1", theme.backgroundColor.description)
        XCTAssertTrue(nil != theme.navigationBarBackground)
        XCTAssertEqual("UIExtendedSRGBColorSpace 0.309804 0.309804 0.309804 1", theme.backgroundSelectedColor.description)
    }
}
