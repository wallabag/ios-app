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
        case badge
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

    static func isBadgeEnable() -> Bool {
        //enabled by default
        if nil == UserDefaults.standard.object(forKey: Const.badge.rawValue) {
            return true
        }
        return UserDefaults.standard.bool(forKey: Const.badge.rawValue)
    }

    static func setBadgeEnable(value: Bool) {
        UserDefaults.standard.set(value, forKey: Const.badge.rawValue)
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

    static func getServer() -> Server? {
        let shareDefaults = UserDefaults(suiteName: "group.wallabag.share_extension")

        guard let serverConfigured = shareDefaults?.object(forKey: "serverConfigured") as? Bool, serverConfigured == true else {
            return nil
        }

        let server = Server(host: shareDefaults?.object(forKey: "host") as? String ?? "",
                            client_secret: shareDefaults?.object(forKey: "clientSecret") as? String ?? "",
                            client_id: shareDefaults?.object(forKey: "clientId") as? String ?? "",
                            username: shareDefaults?.object(forKey: "username") as? String ?? "",
                            password: shareDefaults?.object(forKey: "password") as? String ?? "")

        return server
    }

    static func deleteServer() {
        let shareDefaults = UserDefaults(suiteName: "group.wallabag.share_extension")
        shareDefaults?.removeObject(forKey: "host")
        shareDefaults?.removeObject(forKey: "clientId")
        shareDefaults?.removeObject(forKey: "clientSecret")
        shareDefaults?.removeObject(forKey: "username")
        shareDefaults?.removeObject(forKey: "password")
        shareDefaults?.set(false, forKey: "serverConfigured")
        shareDefaults?.synchronize()
    }
}
