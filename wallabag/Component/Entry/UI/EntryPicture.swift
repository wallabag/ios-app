//
//  EntryPicture.swift
//  wallabag
//
//  Created by Marinel Maxime on 05/11/2019.
//

import Combine
import SwiftUI

struct EntryPicture: View {
    @State private var image: UIImage?

    private let placeholderImage: UIImage = UIImage(systemName: "book")!
    let url: String?

    var body: some View {
        Image(uiImage: image ?? placeholderImage)
            .resizable()
            .scaledToFit()
            .onAppear(perform: loadEntryPicture)
    }

    private func loadEntryPicture() {
        guard let url = url?.url else { return }
        ImageDownloader.shared.loadImage(url: url) { image in
            self.image = image
        }
    }
}
