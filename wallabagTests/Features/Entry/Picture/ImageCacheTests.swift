@testable import wallabag
import XCTest

class ImageCacheTests: XCTestCase {
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

    func testImageCache() async throws {
        let result = await ImageCache.shared.get(name: "test")
        XCTAssertNil(result)

        await ImageCache.shared.set(UIImage(systemName: "book")!, for: "test")

        let result1 = await ImageCache.shared.get(name: "test")
        XCTAssertNotNil(result1)
    }

    func testSubscriptImageCache() async throws {
        let result = await ImageCache.shared["test"]
        XCTAssertNil(result)

        await ImageCache.shared.set(UIImage(systemName: "book")!, for: "test")

        let result1 = await ImageCache.shared["test"]
        XCTAssertNotNil(result1)
    }
}
