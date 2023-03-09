import Foundation

@propertyWrapper
public struct Password {
    private var keychain: KeychainPasswordItem

    public init() {
        keychain = KeychainPasswordItem(service: "wallabag", account: "main", accessGroup: "group.wallabag.share_extension")
    }

    public var wrappedValue: String {
        get { (try? keychain.readPassword()) ?? "" }
        set { try? keychain.savePassword(newValue) }
    }
}
