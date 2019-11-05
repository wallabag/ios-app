//
//  ImageDownloader.swift
//  wallabag
//
//  Created by Marinel Maxime on 05/11/2019.
//

import Foundation
import UIKit

struct ImageDownloader {
    static var shared: ImageDownloader = ImageDownloader()

    private var cache = NSCache<NSString, UIImage>()
    private var dispatchQueue = DispatchQueue(label: "fr.district-web.wallabag.image-downloader", qos: .background)

    private init() {}

    func loadImage(url: URL, completion: @escaping (UIImage) -> Void) {
        if let imageCache = cache.object(forKey: url.absoluteString as NSString) {
            completion(imageCache)
        } else {
            dispatchQueue.async {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data, let image = UIImage(data: data) else { return }
                    self.cache.setObject(image, forKey: url.absoluteString as NSString)
                    completion(image)
                }.resume()
            }
        }
    }
}
