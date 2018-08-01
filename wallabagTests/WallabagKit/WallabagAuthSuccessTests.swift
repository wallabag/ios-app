//
//  WallabagAuthSuccessTests.swift
//  wallabagTests
//
//  Created by maxime marinel on 09/06/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import XCTest
@testable import wallabag
@testable import WallabagKit

class WallabagAuthSuccessTests: XCTestCase {
    func testDecodeAuthSuccess() {
        let json = loadJSON(filename: "AuthSuccess")

        do {
            let decode = try JSONDecoder().decode(WallabagAuthSuccess.self, from: json)
            XCTAssertEqual("MjQyYjk4OWNmODA2ZGZiZTJiNjFiN2I2ZmQ3YTcwODFjYjBiODcwMWFlNmZjNGQ0ZDRkYjgwMTNjMDQyZGUwYQ", decode.accessToken)
            XCTAssertEqual(3600, decode.expiresIn)
            XCTAssertEqual("NDEzZjUyOWZkZDdmYTIxNDY5NDFjODU0M2ZlM2U5MGFmM2E0MWI0YThmNGQ2NmMwY2M1YzI2NTQwN2QyZmM1Mw", decode.refreshToken)
            XCTAssertEqual("bearer", decode.tokenType)
        } catch _ {
            XCTFail()
        }
    }
}
