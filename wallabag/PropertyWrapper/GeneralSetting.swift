//
//  GeneralSetting.swift
//  wallabag
//
//  Created by Marinel Maxime on 14/10/2019.
//

import Foundation

@propertyWrapper
struct GeneralSetting<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
