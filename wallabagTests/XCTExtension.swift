//
//  XCTExtension.swift
//  wallabagTests
//
//  Created by maxime marinel on 09/06/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
    func loadJSON(filename: String) -> Data {
        let path = Bundle(for: type(of: self)).url(forResource: filename, withExtension: "json")!
        return try! Data(contentsOf: path)
    }
}
