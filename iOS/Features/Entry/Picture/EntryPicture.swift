import Combine
import SwiftUI

struct EntryPicture: View {
    @StateObject var imagePublisher = ImageDownloaderPublisher()

    var url: String?

    var body: some View {
        Group {
            if imagePublisher.image != nil {
                Image(uiImage: imagePublisher.image!)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "book")
                    .resizable()
                    .scaledToFit()
            }
        }.task {
            await imagePublisher.loadImage(url: url)
        }
    }
}
