#if os(iOS)
    import Combine
    import Factory
    import Foundation
    import UIKit

    final class ImageDownloaderPublisher: ObservableObject {
        @Injected(\.imageDownloader) private var imageDownloader
        @Published var image: UIImage?

        @MainActor
        func loadImage(url: String?) async {
            guard let url = url?.url else { return }
            image = await imageDownloader.loadImage(url: url)
        }
    }
#endif
