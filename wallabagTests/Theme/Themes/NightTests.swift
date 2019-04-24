//
//  NightTests.swift
//  wallabagTests
//
//  Created by maxime marinel on 24/04/2019.
//

@testable import wallabag
import XCTest

class NightTests: XCTestCase {
    func testNightTheme() {
        let theme = Night()
        XCTAssertEqual("night", theme.name)
        XCTAssertEqual("UIExtendedSRGBColorSpace 0.6 0.6 0.6 1", theme.color.description)
        XCTAssertEqual(.black, theme.barStyle)
        XCTAssertEqual("UIExtendedSRGBColorSpace 0.6 0.6 0.6 1", theme.tintColor.description)
        XCTAssertEqual("UIExtendedSRGBColorSpace 0.133333 0.133333 0.133333 1", theme.backgroundColor.description)
        XCTAssertTrue(nil != theme.navigationBarBackground)
        XCTAssertEqual("UIExtendedSRGBColorSpace 0.219608 0.219608 0.219608 1", theme.backgroundSelectedColor.description)
    }
}
