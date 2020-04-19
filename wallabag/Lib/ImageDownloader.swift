//
//  ImageDownloader.swift
//  wallabag
//
//  Created by Marinel Maxime on 05/11/2019.
//

import Combine
import Foundation
import UIKit

class ImageDownloader {
    static var shared: ImageDownloader = ImageDownloader()

    private var cacheStore = ImageCache.shared

    private var dispatchQueue = DispatchQueue(label: "fr.district-web.wallabag.image-downloader", qos: .background)

    private init() {}

    func loadImage(url: URL) -> AnyPublisher<UIImage?, Never> {
        if let imageCache = cacheStore[url.absoluteString] {
            return Just(imageCache).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: dispatchQueue)
            .compactMap { [unowned self] in
                guard let image = UIImage(data: $0.data) else { return nil }
                self.cacheStore[url.absoluteString] = image
                return image
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
