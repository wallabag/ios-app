//
//  WallabagAuthErrorTests.swift
//  wallabagTests
//
//  Created by maxime marinel on 09/06/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import XCTest
@testable import wallabag
@testable import WallabagKit

class WallabagAuthErrorTests: XCTestCase {
    func testDecodeAuthErrorWrongPassword() {
        let json = loadJSON(filename: "AuthWrongPassword")

        do {
            let decode = try JSONDecoder().decode(WallabagAuthError.self, from: json)
            XCTAssertEqual("Invalid username and password combination", decode.description)
            XCTAssertEqual("invalid_grant", decode.error)
        } catch _ {
            XCTFail()
        }
    }
}
