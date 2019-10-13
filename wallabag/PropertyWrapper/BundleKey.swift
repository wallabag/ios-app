//
//  BundleKey.swift
//  wallabag
//
//  Created by Marinel Maxime on 10/10/2019.
//

import Foundation

@propertyWrapper
class BundleKey {
    let key: String

    var wrappedValue: String {
        Bundle.main.infoDictionary![key] as? String ?? ""
    }

    init(_ key: String) {
        self.key = key
    }
}
