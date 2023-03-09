import Combine
import Foundation
#if canImport(UIKit)
    import UIKit
#endif

final class ImageDownloader {
    private var cacheStore = ImageCache.shared

    private var dispatchQueue = DispatchQueue(label: "fr.district-web.wallabag.image-downloader", qos: .background)

    func loadImage(url: URL) async -> UIImage? {
        if let imageCache = await cacheStore[url.absoluteString] {
            return imageCache
        }

        var request = URLRequest(url: url)
        request.allowsConstrainedNetworkAccess = false

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            guard let image = UIImage(data: data) else { return nil }

            await cacheStore.set(image, for: url.absoluteString)

            return image
        } catch {}

        return nil
    }
}
