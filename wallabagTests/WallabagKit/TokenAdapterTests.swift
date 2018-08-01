//
//  TokenAdapterTests.swift
//  wallabagTests
//
//  Created by maxime marinel on 09/06/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import XCTest
@testable import wallabag
@testable import WallabagKit

class TokenAdapterTests: XCTestCase {
    
    func testAdapt() {
        let adapter = TokenAdapter(accessToken: "my_token")
        let mainRequest = URLRequest(url: URL(string: "http://localhost")!)

        do {
            let request = try adapter.adapt(mainRequest)
            XCTAssertEqual("Bearer my_token", request.value(forHTTPHeaderField: "Authorization")!)
        } catch _ {
            XCTFail()
        }
    }
}
