import Combine
import SwiftUI

struct EntryPicture: View {
    @ObservedObject var imagePublisher: ImageDownloaderPublisher

    init(url: String?) {
        imagePublisher = ImageDownloaderPublisher(url: url)
    }

    var body: some View {
        if imagePublisher.image != nil {
            Image(uiImage: imagePublisher.image!)
                .resizable()
                .scaledToFit()
        } else {
            Image(systemName: "book")
                .resizable()
                .scaledToFit()
        }
    }
}
