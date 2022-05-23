import Combine
@testable import wallabag
import XCTest

class ImageDownloaderTests: XCTestCase {
    var cancellable: AnyCancellable?

    override func setUp() {
        Task {
            await ImageCache.shared.purge()
        }
    }

    override func tearDown() {
        Task {
            await ImageCache.shared.purge()
        }
    }

    func testLoadInvalidImage() async throws {
        let imageDownloader = ImageDownloader.shared

        let image = await imageDownloader.loadImage(url: .init(string: "https://wallabag.it/")!)

        XCTAssertNil(image)
    }

    func testLoadValidImage() async throws {
        let imageDownloader = ImageDownloader.shared

        let image = await imageDownloader.loadImage(url: .init(string: "https://www.wallabag.it/user/themes/alpha/assets/images/wallabagit.png")!)

        XCTAssertNotNil(image)
    }
}
