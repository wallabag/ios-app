import Foundation

@propertyWrapper
struct Setting<T> {
    let key: String
    let defaultValue: T
    let userDefaults = UserDefaults(suiteName: "group.wallabag.share_extension")!

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            userDefaults.object(forKey: key) as? T ?? defaultValue
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }
}
