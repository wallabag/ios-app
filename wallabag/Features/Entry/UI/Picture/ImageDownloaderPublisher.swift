//
//  ImageDownloaderPublisher.swift
//  wallabag
//
//  Created by Marinel Maxime on 19/04/2020.
//

import Combine
import Foundation
import UIKit.UIImage

class ImageDownloaderPublisher: ObservableObject {
    @Published var image: UIImage?

    private var cancellable: Cancellable?
    private let url: URL?

    init(url: String?) {
        self.url = url?.url

        loadImage()
    }

    func loadImage() {
        guard let url = url else { return }
        cancellable = ImageDownloader.shared.loadImage(url: url)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
}
