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
    @Setting("host", defaultValue: "")
    static var host: String

    @Setting("clientId", defaultValue: "")
    static var clientId: String

    @Setting("clientSecret", defaultValue: "")
    static var clientSecret: String

    @Setting("username", defaultValue: "")
    static var login: String

    static var password: String {
        get { return (try? keychain.readPassword()) ?? "" }
        set { try? keychain.savePassword(newValue) }
    }

    @Setting("registred", defaultValue: false)
    static var registred: Bool

    @Setting("accessToken", defaultValue: nil)
    static var accessToken: String?

    @Setting("refreshToken", defaultValue: nil)
    static var refreshToken: String?

    @Setting("expiresIn", defaultValue: nil)
    static var expiresIn: Int?
}
