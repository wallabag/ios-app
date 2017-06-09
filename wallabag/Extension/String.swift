//
//  String.swift
//  wallabag
//
//  Created by maxime marinel on 22/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import Foundation

private class Localizator {

    static let sharedInstance = Localizator()

    lazy var localizableDictionary: NSDictionary! = {
        if let path = Bundle.main.path(forResource: "Localizable", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        fatalError("Localizable file NOT found")
    }()

    func localize(string: String) -> String {
        guard let localizedString = localizableDictionary.value(forKey: string) as? String else {
            //assertionFailure("Localized string not found")
            return string
        }

        return localizedString
    }
}

extension String {
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

        return dateFormatter.date(from: self)
    }

    var ucFirst: String {
        let first = String(self.characters.prefix(1))

        return first.uppercased() + String(characters.dropFirst())
    }

    var lcFirst: String {
        let first = String(self.characters.prefix(1))

        return first.lowercased() + String(characters.dropFirst())
    }

    var withoutHTML: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }

    var localized: String {
        return Localizator.sharedInstance.localize(string: self)
    }
}
