//
//  WhiteTests.swift
//  wallabagTests
//
//  Created by maxime marinel on 24/04/2019.
//

@testable import wallabag
import XCTest

class WhiteTests: XCTestCase {
    func testWhiteTheme() {
        let theme = White()
        XCTAssertEqual("white", theme.name)
        XCTAssertEqual("UIExtendedGrayColorSpace 0 1", theme.color.description)
        XCTAssertEqual(.default, theme.barStyle)
        XCTAssertEqual("UIExtendedGrayColorSpace 0 1", theme.tintColor.description)
        XCTAssertEqual("UIExtendedGrayColorSpace 1 1", theme.backgroundColor.description)
        XCTAssertTrue(nil == theme.navigationBarBackground)
        XCTAssertEqual("UIExtendedSRGBColorSpace 0.898039 0.898039 0.898039 1", theme.backgroundSelectedColor.description)
    }
}
