//
//  password.swift
//  wallabag
//
//  Created by Marinel Maxime on 22/07/2019.
//

import Foundation

@propertyWrapper
struct Password {
    private var keychain: KeychainPasswordItem

    var wrappedValue: String {
        get { return (try? keychain.readPassword()) ?? "" }
        set { try? keychain.savePassword(newValue) }
    }

    init() {
        keychain = KeychainPasswordItem(service: "wallabag", account: "main")
    }
}
