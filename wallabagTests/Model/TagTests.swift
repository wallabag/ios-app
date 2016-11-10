//
//  Tag.swift
//  wallabag
//
//  Created by maxime marinel on 10/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import XCTest
@testable import wallabag

class TagTests: XCTestCase {

    func testTagFromDict() {
        let tag = Tag(fromDictionary: [
            "id": 42,
            "label": "My tag",
            "slug": "my-tag",
        ])

        XCTAssertEqual(42, tag.id)
        XCTAssertEqual("My tag", tag.label)
        XCTAssertEqual("my-tag", tag.slug)
    }

}
