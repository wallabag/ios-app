//
//  WallabagUserDefaults.swift
//  wallabag
//
//  Created by Marinel Maxime on 20/07/2019.
//

import Foundation

struct WallabagUserDefaults {
    @Setting("host", defaultValue: "")
    static var host: String

    @Setting("clientId", defaultValue: "")
    static var clientId: String

    @Setting("clientSecret", defaultValue: "")
    static var clientSecret: String

    @Setting("username", defaultValue: "")
    static var login: String

    @Password()
    static var password: String

    @Setting("registred", defaultValue: false)
    static var registred: Bool

    @Setting("accessToken", defaultValue: nil)
    static var accessToken: String?

    @Setting("refreshToken", defaultValue: nil)
    static var refreshToken: String?

    @Setting("expiresIn", defaultValue: nil)
    static var expiresIn: Int?

    @Setting("previousPasteBoardUrl", defaultValue: "")
    static var previousPasteBoardUrl: String

    @GeneralSetting("justifyArticle", defaultValue: true)
    static var justifyArticle: Bool

    @GeneralSetting("badge", defaultValue: true)
    static var badgeEnabled: Bool

    @GeneralSetting("defaultMode", defaultValue: "allArticles")
    static var defaultMode: String

    @Setting("webFontSizePercent", defaultValue: 100)
    static var webFontSizePercent: Double

    @GeneralSetting("showImageInList", defaultValue: true)
    static var showImageInList: Bool
}
