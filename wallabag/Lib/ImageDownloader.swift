//
//  ImageDownloader.swift
//  wallabag
//
//  Created by maxime marinel on 27/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

final class ImageDownloader {

    typealias CompletionImageDownloaderHandler = (UIImage) -> Void

    static var cache: NSCache = NSCache<NSString, UIImage>()

    static func downloadImage(fromString urlString: String, completion: @escaping CompletionImageDownloaderHandler) {
        if cache.object(forKey: urlString as NSString) == nil {
            URLSession.shared.dataTask(with: URL(string: urlString)!) { data, response, error in
                if let imageData = data as Data? {
                    guard let image = UIImage(data: imageData) else {
                        //completion(UIImage())
                        return
                    }

                    cache.setObject(image, forKey: urlString as NSString)
                    completion(image)
                } else {
                    print("[Image downloader] : Image not found \(urlString)")
                }

            }.resume()
        } else {
            completion(cache.object(forKey: urlString as NSString)!)
        }
    }
}

extension UIImageView {

    public func image(fromString urlString: String) {
        ImageDownloader.downloadImage(fromString: urlString) { image in
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
        }
    }

}
