import Foundation

@propertyWrapper
struct BundleKey {
    let key: String

    var wrappedValue: String {
        Bundle.main.infoDictionary![key] as? String ?? ""
    }

    init(_ key: String) {
        self.key = key
    }
}
