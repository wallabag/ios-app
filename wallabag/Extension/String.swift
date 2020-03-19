//
//  String.swift
//  wallabag
//
//  Created by maxime marinel on 22/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import Foundation

extension String {
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

    /**
     * Check if string is valid URL
     */
    var isValidURL: Bool {
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [regEx])
        return predicate.evaluate(with: self)
    }
}
