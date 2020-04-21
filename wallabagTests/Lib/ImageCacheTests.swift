//
//  ImageCacheTests.swift
//  wallabagTests
//
//  Created by Marinel Maxime on 21/04/2020.
//

@testable import wallabag
import XCTest

class ImageCacheTests: XCTestCase {
    override func setUp() {
        ImageCache.shared.purge()
    }

    override func tearDown() {
        ImageCache.shared.purge()
    }

    func testImageCache() throws {
        XCTAssertNil(ImageCache.shared.get(name: "test"))

        ImageCache.shared.set(UIImage(systemName: "book")!, for: "test")

        XCTAssertNotNil(ImageCache.shared.get(name: "test"))
    }

    func testSubscriptImageCache() throws {
        XCTAssertNil(ImageCache.shared["test"])

        ImageCache.shared["test"] = UIImage(systemName: "book")!

        XCTAssertNotNil(ImageCache.shared["test"])
    }
}
