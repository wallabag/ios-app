#if os(iOS)
    import Factory
    import Foundation
    import Observation
    import SwiftUI
    import UIKit

    @Observable
    final class ImageDownloaderPublisher {
        @ObservationIgnored
        @Injected(\.imageDownloader) private var imageDownloader
        var image: UIImage?

        @MainActor
        func loadImage(url: String?) async {
            guard let url = url?.url else { return }
            image = await imageDownloader.loadImage(url: url)
        }
    }
#endif
