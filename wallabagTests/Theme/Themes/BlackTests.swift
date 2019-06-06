//
//  BlackTests.swift
//  wallabagTests
//
//  Created by maxime marinel on 24/04/2019.
//

@testable import wallabag
import XCTest

class BlackTests: XCTestCase {
    func testBlackTheme() {
        let theme = Black()
        XCTAssertEqual("black", theme.name)
        XCTAssertEqual("UIExtendedSRGBColorSpace 0.392157 0.392157 0.392157 1", theme.color.description)
        XCTAssertEqual(.black, theme.barStyle)
        XCTAssertEqual("UIExtendedSRGBColorSpace 0.392157 0.392157 0.392157 1", theme.tintColor.description)
        XCTAssertEqual("UIExtendedSRGBColorSpace 0 0 0 1", theme.backgroundColor.description)
        XCTAssertTrue(nil != theme.navigationBarBackground)
        XCTAssertEqual("UIExtendedSRGBColorSpace 0.0392157 0.0392157 0.0392157 1", theme.backgroundSelectedColor.description)
    }
}
