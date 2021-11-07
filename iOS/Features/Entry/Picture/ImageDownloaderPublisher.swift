import Combine
import Foundation
import UIKit.UIImage

final class ImageDownloaderPublisher: ObservableObject {
    @Published var image: UIImage?

    @MainActor
    func loadImage(url: String?) async {
        guard let url = url?.url else { return }
        image = await ImageDownloader.shared.loadImage(url: url)
    }
}
