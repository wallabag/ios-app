//
//  ImageCache.swift
//  wallabag
//
//  Created by Marinel Maxime on 19/04/2020.
//

import Foundation
import UIKit.UIImage

// Implement memory Warning?
class ImageCache {

    static var shared = ImageCache()

    private var cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        //Using cost limit ?
        //cache.totalCostLimit
        //Using count limit ?
        //cache.countLimit = 40
        return cache
    }()

    private init() {}

    subscript(name: String) -> UIImage? {
        get {
            if let imageCacheMemory = cache.object(forKey: name.NSString) {
                return imageCacheMemory
           }

            if let imageCacheDir = load(name: name) {
                cache.setObject(imageCacheDir, forKey: name.NSString)
                return imageCacheDir
            }

            return nil
        }
        set {
            guard let image = newValue else { return }
            store(image: image, name: name)
        }
    }

    func store(image: UIImage, name: String) {
        cache.setObject(image, forKey: name as NSString)
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let filename = url.appendingPathComponent("\(name.md5).png")

        // Or Jpeg with compression?
        try? image.pngData()?.write(to: filename)
    }

    private func load(name: String) -> UIImage? {
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent("\(name.md5).png").path)
    }
}
