//
//  ImageDownloaderTests.swift
//  wallabagTests
//
//  Created by Marinel Maxime on 21/04/2020.
//

import Combine
@testable import wallabag
import XCTest

class ImageDownloaderTests: XCTestCase {
    var cancellable: AnyCancellable?

    override func setUp() {
        // Mock this
        ImageCache.shared.purge()
    }

    override func tearDown() {
        // Mock this
        ImageCache.shared.purge()
    }

    func xtestLoadInvalidImage() throws {
        let imageDownloader = ImageDownloader.shared

        let expect = expectation(description: #function)

        cancellable = imageDownloader.loadImage(url: URL(string: "https://wallabag.it/")!)
            .sink(receiveCompletion: { completion in
                if completion == .finished {
                    expect.fulfill()
                }
            }, receiveValue: { _ in
            })

        wait(for: [expect], timeout: 5)
    }

    func xtestLoadValidImage() throws {
        let imageDownloader = ImageDownloader.shared

        let expect = expectation(description: #function)

        cancellable = imageDownloader.loadImage(url: URL(string: "https://www.wallabag.it/user/themes/alpha/assets/images/wallabagit.png")!)
            .sink(receiveValue: { image in
                expect.fulfill()
                XCTAssertNotNil(image)
            })

        wait(for: [expect], timeout: 5)
    }
}
