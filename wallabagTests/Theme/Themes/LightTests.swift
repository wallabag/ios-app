//
//  LightTests.swift
//  wallabagTests
//
//  Created by maxime marinel on 24/04/2019.
//

@testable import wallabag
import XCTest

class LightTests: XCTestCase {
    func testLightTheme() {
        let theme = Light()
        XCTAssertEqual("light", theme.name)
        XCTAssertEqual("UIExtendedSRGBColorSpace 0.25098 0.25098 0.25098 1", theme.color.description)
        XCTAssertEqual(.default, theme.barStyle)
        XCTAssertEqual("UIExtendedSRGBColorSpace 0.25098 0.25098 0.25098 1", theme.tintColor.description)
        XCTAssertEqual("UIExtendedSRGBColorSpace 0.964706 0.937255 0.862745 1", theme.backgroundColor.description)
        XCTAssertTrue(nil != theme.navigationBarBackground)
        XCTAssertEqual("UIExtendedSRGBColorSpace 0.866667 0.843137 0.776471 1", theme.backgroundSelectedColor.description)
    }
}
