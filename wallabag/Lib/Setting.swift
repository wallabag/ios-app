//
//  Setting.swift
//  wallabag
//
//  Created by maxime marinel on 23/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import Foundation

class Setting {

    enum Const: String {
        case defaultMode
        case justifyArticle
        case articleTheme
    }

    static func getDefaultMode() -> RetrieveMode {
        guard let value = UserDefaults.standard.string(forKey: Const.defaultMode.rawValue) else {
            return RetrieveMode.allArticles
        }
        return RetrieveMode(rawValue: value)!
    }

    static func setDefaultMode(mode: RetrieveMode) {
        UserDefaults.standard.set(mode.rawValue, forKey: Const.defaultMode.rawValue)
    }

    static func isJustifyArticle() -> Bool {
        return UserDefaults.standard.bool(forKey: Const.justifyArticle.rawValue)
    }

    static func setJustifyArticle(value: Bool) {
        UserDefaults.standard.set(value, forKey: Const.justifyArticle.rawValue)
    }

    static func getTheme() -> ThemeManager.Theme {
        guard let value = UserDefaults.standard.string(forKey: Const.articleTheme.rawValue) else {
            return ThemeManager.Theme.light
        }

        return ThemeManager.Theme(rawValue: value) ?? .light
    }

    static func setTheme(value: ThemeManager.Theme) {
        UserDefaults.standard.set(value.rawValue, forKey: Const.articleTheme.rawValue)
        ThemeManager.apply(theme: value)
    }

    static func set(server: Server) {
        let shareDefaults = UserDefaults(suiteName: "group.wallabag.share_extension")
        shareDefaults?.set(server.host, forKey: "host")
        shareDefaults?.set(server.client_id, forKey: "clientId")
        shareDefaults?.set(server.client_secret, forKey: "clientSecret")
        shareDefaults?.set(server.username, forKey: "username")
        shareDefaults?.set(server.password, forKey: "password")
        shareDefaults?.set(true, forKey: "serverConfigured")
        shareDefaults?.synchronize()
    }
}
