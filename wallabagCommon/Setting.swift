//
//  Setting.swift
//  wallabag
//
//  Created by maxime marinel on 23/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import AVFoundation
import Foundation

public class SettingKeys {}

public final class SettingKey<SettingType>: SettingKeys {
    public let key: String
    public let defaultParameter: SettingType
    public init(_ key: String, _ defaultParameter: SettingType) {
        self.key = key
        self.defaultParameter = defaultParameter
    }
}

public class Setting {
    let defaults: UserDefaults

    init(_ defaults: UserDefaults) {
        self.defaults = defaults
    }

    public func get<ValueType>(for key: SettingKey<ValueType>) -> ValueType {
        guard let value = defaults.value(forKey: key.key) as? ValueType else {
            return key.defaultParameter
        }
        return value
    }

    public func set<ValueType>(_ value: ValueType, for key: SettingKey<ValueType>) {
        defaults.set(value, forKey: key.key)
        defaults.synchronize()
    }

    public func reset(suiteName: String) {
        defaults.removeSuite(named: suiteName)
        defaults.removePersistentDomain(forName: suiteName)
        defaults.synchronize()
    }
}

public protocol SettingProtocol {
    func get<ValueType>(for key: SettingKey<ValueType>) -> ValueType

    func set<ValueType>(_ value: ValueType, for key: SettingKey<ValueType>)

    func set(password: String, username: String) 
}

public class WallabagSetting: Setting, SettingProtocol {
    public let sharedDomain = "group.wallabag.share_extension"
    public init() {
        super.init(UserDefaults(suiteName: sharedDomain)!)
    }

    public func getPassword() -> String? {
        guard "" != get(for: .username) else {
            return nil
        }
        let keychain = KeychainPasswordItem(service: "wallabag", account: get(for: .username), accessGroup: sharedDomain)
        do {
            return try keychain.readPassword()
        } catch {
            return nil
        }
    }

    public func set(password: String, username: String) {
        let keychain = KeychainPasswordItem(service: "wallabag", account: username, accessGroup: sharedDomain)
        do {
            try keychain.savePassword(password)
        } catch {
            fatalError()
        }
    }

    public func getSpeechVoice() -> AVSpeechSynthesisVoice? {
        return AVSpeechSynthesisVoice(identifier: get(for: .speechVoice))
    }
}

public extension SettingKeys {
    static let wallabagIsConfigured = SettingKey<Bool>("wallabagConfiguredV3.1", false)
    static let host = SettingKey<String>("host", "")
    static let username = SettingKey<String>("username", "")
    static let clientId = SettingKey<String>("clientId", "")
    static let clientSecret = SettingKey<String>("clientSecret", "")
    static let speechVoice = SettingKey<String>("speechVoice", "com.apple.ttsbundle.Daniel-compact")
    static let badgeEnabled = SettingKey<Bool>("badge", true)
    static let defaultMode = SettingKey<String>("defaultMode", "allArticles")
    static let previousPasteBoardUrl = SettingKey<String>("previousPasteBoardUrl", "")
    static let speechRate = SettingKey<Float>("speechRate", AVSpeechUtteranceDefaultSpeechRate)
    static let justifyArticle = SettingKey<Bool>("justifyArticle", true)
    static let theme = SettingKey<String>("theme", "white")
}
