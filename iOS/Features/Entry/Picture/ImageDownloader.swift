import Combine
import Foundation
#if canImport(UIKit)
    import UIKit
#endif

class ImageDownloader {
    static var shared = ImageDownloader()

    private var cacheStore = ImageCache.shared

    private var dispatchQueue = DispatchQueue(label: "fr.district-web.wallabag.image-downloader", qos: .background)

    private init() {}

    func loadImage(url: URL) -> AnyPublisher<UIImage?, Never> {
        if let imageCache = cacheStore[url.absoluteString] {
            return Just(imageCache).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.allowsConstrainedNetworkAccess = false

        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: dispatchQueue)
            .compactMap { [unowned self] in
                guard let image = UIImage(data: $0.data) else { return nil }
                self.cacheStore[url.absoluteString] = image
                return image
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
