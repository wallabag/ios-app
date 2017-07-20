//
//  Setting.swift
//  wallabag
//
//  Created by maxime marinel on 23/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import Foundation
import WallabagKit

class Setting {

    static let sharedDomain = "group.wallabag.share_extension"
    static var standard = UserDefaults.standard
    static var shared = UserDefaults(suiteName: sharedDomain)!

    enum RetrieveMode: String {
        case allArticles
        case archivedArticles
        case unarchivedArticles
        case starredArticles

        public func humainReadable() -> String {
            switch self {
            case .allArticles:
                return "All articles"
            case .archivedArticles:
                return "Read articles"
            case .starredArticles:
                return "Starred articles"
            case .unarchivedArticles:
                return "Unread articles"
            }
        }
    }

    enum Const: String {
        case defaultMode
        case justifyArticle
        case articleTheme
        case badge
        case speechRate
    }

    static func getDefaultMode() -> RetrieveMode {
        guard let value = standard.string(forKey: Const.defaultMode.rawValue) else {
            return .allArticles
        }
        return RetrieveMode(rawValue: value)!
    }

    static func setDefaultMode(mode: RetrieveMode) {
        standard.set(mode.rawValue, forKey: Const.defaultMode.rawValue)
    }

    static func isJustifyArticle() -> Bool {
        return standard.bool(forKey: Const.justifyArticle.rawValue)
    }

    static func setJustifyArticle(value: Bool) {
        standard.set(value, forKey: Const.justifyArticle.rawValue)
    }

    static func isBadgeEnable() -> Bool {
        //enabled by default
        if nil == standard.object(forKey: Const.badge.rawValue) {
            return true
        }
        return standard.bool(forKey: Const.badge.rawValue)
    }

    static func setBadgeEnable(value: Bool) {
        standard.set(value, forKey: Const.badge.rawValue)
    }

    static func setSpeechRate(value: Float) {
        standard.set(value, forKey: Const.speechRate.rawValue)
    }

    static func getSpeechRate() -> Float {
        guard standard.value(forKey: Const.speechRate.rawValue) != nil else {
            return 0.5
        }
        return standard.float(forKey: Const.speechRate.rawValue)
    }

    static func getTheme() -> String {
        guard let value = standard.string(forKey: Const.articleTheme.rawValue) else {
            return "white"
        }

        return value
    }

    static func setTheme(value: String) {
        standard.set(value, forKey: Const.articleTheme.rawValue)
    }

    static func deleteServer() {
        shared.removeObject(forKey: "host")
        shared.removeObject(forKey: "clientId")
        shared.removeObject(forKey: "clientSecret")
        shared.removeObject(forKey: "username")
        shared.removeObject(forKey: "password")
        shared.removeObject(forKey: "token")
        shared.removeObject(forKey: "refreshToken")
        shared.synchronize()
    }

    static func purge() {
        defer {
            standard.synchronize()
            shared.synchronize()
        }
        standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        deleteServer()
        shared.removeSuite(named: sharedDomain)
        shared.removePersistentDomain(forName: sharedDomain)
    }
}
