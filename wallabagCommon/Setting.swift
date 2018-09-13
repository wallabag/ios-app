//
//  Setting.swift
//  wallabag
//
//  Created by maxime marinel on 23/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import Foundation
import AVFoundation

public class SettingKeys {}

public final class SettingKey<SettingType>: SettingKeys {
    let key: String
    let defaultParameter: SettingType
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
}

public class WallabagSetting: Setting {
    let sharedDomain = "group.wallabag.share_extension"
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
    public static let wallabagIsConfigured = SettingKey<Bool>("wallabagConfiguredV3", false)
    public static let host = SettingKey<String>("host", "")
    public static let username = SettingKey<String>("username", "")
    public static let clientId = SettingKey<String>("clientId", "")
    public static let clientSecret = SettingKey<String>("clientSecret", "")
    public static let speechVoice = SettingKey<String>("speechVoice", "com.apple.ttsbundle.Daniel-compact")
    public static let badgeEnabled = SettingKey<Bool>("badge", true)
    public static let defaultMode = SettingKey<String>("defaultMode", "allArticles")
    public static let previousPasteBoardUrl = SettingKey<String>("previousPasteBoardUrl", "")
    public static let speechRate = SettingKey<Float>("speechRate", AVSpeechUtteranceDefaultSpeechRate)
    public static let justifyArticle = SettingKey<Bool>("justifyArticle", true)
    public static let theme = SettingKey<String>("theme", "white")
}
