//
//  WallabagUserDefaults.swift
//  wallabag
//
//  Created by Marinel Maxime on 20/07/2019.
//

import Foundation
import WallabagCommon

struct WallabagUserDefaults {
    static let keychain: KeychainPasswordItem = KeychainPasswordItem(service: "wallabag", account: "main")
    @UserDefault("host", defaultValue: "")
    static var host: String

    @UserDefault("clientId", defaultValue: "")
    static var clientId: String

    @UserDefault("clientSecret", defaultValue: "")
    static var clientSecret: String

    @UserDefault("username", defaultValue: "")
    static var login: String

    static var password: String {
        get { return (try? keychain.readPassword()) ?? "" }
        set { try? keychain.savePassword(newValue) }
    }

    @UserDefault("registred", defaultValue: false)
    static var registred: Bool
}
