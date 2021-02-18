import Foundation

@propertyWrapper
struct Password {
    private var keychain: KeychainPasswordItem

    var wrappedValue: String {
        get { (try? keychain.readPassword()) ?? "" }
        set { try? keychain.savePassword(newValue) }
    }

    init() {
        keychain = KeychainPasswordItem(service: "wallabag", account: "main", accessGroup: "group.wallabag.share_extension")
    }
}
