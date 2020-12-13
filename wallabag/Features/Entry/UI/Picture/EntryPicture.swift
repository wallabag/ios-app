import Combine
import SwiftUI

struct EntryPicture: View {
    private let placeholderImage = UIImage(systemName: "book")!

    @ObservedObject var imagePublisher: ImageDownloaderPublisher

    init(url: String?) {
        imagePublisher = ImageDownloaderPublisher(url: url)
    }

    var body: some View {
        Image(uiImage: imagePublisher.image ?? placeholderImage)
            .resizable()
            .scaledToFit()
    }
}
