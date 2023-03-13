import Combine
import SwiftUI

struct EntryPicture: View {
    #if os(iOS)
        @StateObject var imagePublisher = ImageDownloaderPublisher()
    #endif

    var url: String?

    var body: some View {
        Group {
            #if os(iOS)
                if let image = imagePublisher.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "book")
                        .resizable()
                        .scaledToFit()
                }
            #endif
        }.task {
            #if os(iOS)
                await imagePublisher.loadImage(url: url)
            #endif
        }
    }
}
