import Combine
import Foundation
#if canImport(UIKit)
    import UIKit
#endif

class ImageCache {
    static var shared = ImageCache()

    private var memoryCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        // set limit?
        return cache
    }()

    private var cancellable: Cancellable?

    private init() {
        cancellable = NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)
            .sink(receiveValue: clearMemoryCache)
    }

    private func clearMemoryCache(_: Notification?) {
        memoryCache.removeAllObjects()
    }

    subscript(name: String) -> UIImage? {
        get {
            get(name: name)
        }
        set {
            guard let image = newValue else { return }
            set(image, for: name)
        }
    }

    func set(_ image: UIImage, for name: String) {
        memoryCache.setObject(image, forKey: name as NSString)

        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let filename = url.appendingPathComponent("\(name.md5).png")

        try? image.pngData()?.write(to: filename)
    }

    func get(name: String) -> UIImage? {
        if let imageCacheMemory = memoryCache.object(forKey: name.NSString) {
            return imageCacheMemory
        }

        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let imageCacheDir = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent("\(name.md5).png").path)

        if imageCacheDir != nil {
            memoryCache.setObject(imageCacheDir!, forKey: name.NSString)

            return imageCacheDir
        }

        return nil
    }

    func purge() {
        clearMemoryCache(nil)

        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: url.path)
            try files.forEach {
                try FileManager.default.removeItem(atPath: url.appendingPathComponent($0).path)
            }
        } catch {
            print("Error in cache purge")
        }
    }
}
