import CryptoKit
import Foundation

public extension String {
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

        return dateFormatter.date(from: self)
    }

    var ucFirst: String {
        let first = String(prefix(1))

        return first.uppercased() + String(dropFirst())
    }

    var lcFirst: String {
        let first = String(prefix(1))

        return first.lowercased() + String(dropFirst())
    }

    var withoutHTML: String {
        replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }

    var speakable: [String] {
        replacingOccurrences(of: "<p[^>]+>", with: "<p>", options: .regularExpression, range: nil).components(separatedBy: "<p>").filter { $0.count > 0 }
    }

    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    var url: URL? {
        URL(string: self)
    }

    @available(iOS 13.0, macOS 10.15, *)
    var md5: String {
        Insecure.MD5.hash(data: data(using: .utf8)!).map {
            String(format: "%02hhx", $0)
        }.joined()
    }

    var NSString: NSString {
        self as NSString
    }

    /**
     * Check if string is valid URL
     */
    var isValidURL: Bool {
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/]|[:\\d+])((\\w|-)+))+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [regEx])
        return predicate.evaluate(with: self)
    }

    var int: Int? {
        Int(self)
    }
}
