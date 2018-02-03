//
//  Setting.swift
//  wallabag
//
//  Created by maxime marinel on 23/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import Foundation
import WallabagKit
import AVFoundation

class Setting {

    static let sharedDomain = "group.wallabag.share_extension"
    static var standard = UserDefaults.standard
    static var shared = UserDefaults(suiteName: sharedDomain)!

    enum RetrieveMode: String {
        case allArticles
        case archivedArticles
        case unarchivedArticles
        case starredArticles

        func humainReadable() -> String {
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

        func predicate() -> NSPredicate {
            switch self {
            case .unarchivedArticles:
                return NSPredicate(format: "is_archived == 0")
            case .starredArticles:
                return NSPredicate(format: "is_starred == 1")
            case .archivedArticles:
                return NSPredicate(format: "is_archived == 1")
            case .allArticles:
                return NSPredicate(value: true)
            }
        }
    }

    enum Const: String {
        case defaultMode
        case justifyArticle
        case articleTheme
        case badge
        case speechRate
        case speechVoice
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

    static func getSpeechVoice() -> AVSpeechSynthesisVoice? {
        return AVSpeechSynthesisVoice(identifier: standard.string(forKey: Const.speechVoice.rawValue) ?? "com.apple.ttsbundle.Daniel-compact")
    }

    static func setSpeechVoice(identifier: String) {
        standard.set(identifier, forKey: Const.speechVoice.rawValue)
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
        shared.removeObject(forKey: "wallabagConfigured")
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

    public static func set(host: String) {
        shared.set(host, forKey: "host")
    }

    public static func getHost() -> String? {
        return shared.string(forKey: "host")
    }

    public static func set(token: String) {
        shared.set(token, forKey: "token")
    }

    public static func getToken() -> String? {
        return shared.string(forKey: "token")
    }

    public static func set(refreshToken: String) {
        shared.set(refreshToken, forKey: "refreshToken")
    }

    public static func getRefreshToken() -> String? {
        return shared.string(forKey: "refreshToken")
    }

    public static func set(clientId: String) {
        shared.set(clientId, forKey: "clientId")
    }

    public static func getClientId() -> String? {
        return shared.string(forKey: "clientId")
    }

    public static func set(clientSecret: String) {
        shared.set(clientSecret, forKey: "clientSecret")
    }

    public static func getClientSecret() -> String? {
        return shared.string(forKey: "clientSecret")
    }

    public static func set(username: String) {
        shared.set(username, forKey: "username")
    }

    public static func getUsername() -> String? {
        return shared.string(forKey: "username")
    }

    public static func set(password: String, username: String) {
        let keychain = KeychainPasswordItem(service: "wallabag", account: username, accessGroup: sharedDomain)
        do {
            try keychain.savePassword(password)
        } catch {
            fatalError()
        }
    }

    public static func getPassword(username: String) -> String? {
        let keychain = KeychainPasswordItem(service: "wallabag", account: username, accessGroup: sharedDomain)
        do {
            return try keychain.readPassword()
        } catch {
            return ""
        }
    }

    public static func set(wallabagConfigured: Bool) {
        shared.set(wallabagConfigured, forKey: "wallabagConfigured")
    }

    public static func isWallabagConfigured() -> Bool {
        return shared.bool(forKey: "wallabagConfigured")
    }
}
