import SwiftUI
#if os(iOS)
    import Combine
    import UIKit

    struct EntryPicture: View {
        @StateObject var imagePublisher = ImageDownloaderPublisher()

        var url: String?

        var body: some View {
            Group {
                if let image = imagePublisher.image {
                    Image(uiImage: image)
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
#endif

#if os(macOS)
    struct EntryPicture: View {
        var url: String?

        var body: some View {
            if let url {
                AsyncImage(url: URL(string: url)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    placeholder
                }

            } else {
                placeholder
            }
        }

        private var placeholder: some View {
            Image(systemName: "book")
                .resizable()
                .scaledToFit()
        }
    }
#endif
