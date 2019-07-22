//
//  WallabagUserDefaults.swift
//  wallabag
//
//  Created by Marinel Maxime on 20/07/2019.
//

import Foundation

struct WallabagUserDefaults {
    @UserDefault("host", defaultValue: "")
    static var host: String
}

@propertyWrapper
struct UserDefault<T> {
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
