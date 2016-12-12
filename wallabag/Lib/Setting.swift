//
//  Setting.swift
//  wallabag
//
//  Created by maxime marinel on 23/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import Foundation

class Setting {

    enum Theme: String {
        case none
        case gray

        static let allThemes: [Theme] = [.none, gray]
    }

    fileprivate enum const: String {
        case defaultMode
        case justifyArticle
        case articleTheme
    }

    static func getDefaultMode() -> RetrieveMode {
        guard let value = UserDefaults.standard.string(forKey: const.defaultMode.rawValue) else {
            return RetrieveMode.allArticles
        }
        return RetrieveMode(rawValue: value)!
    }

    static func setDefaultMode(mode: RetrieveMode) {
        UserDefaults.standard.set(mode.rawValue, forKey: const.defaultMode.rawValue)
    }

    static func isJustifyArticle() -> Bool {
        return UserDefaults.standard.bool(forKey: const.justifyArticle.rawValue)
    }

    static func setJustifyArticle(value: Bool) {
        UserDefaults.standard.set(value, forKey: const.justifyArticle.rawValue)
    }

    static func getArticleTheme() -> String {
        guard let value = UserDefaults.standard.string(forKey: const.articleTheme.rawValue) else {
            return Theme.none.rawValue
        }

        return value
    }

    static func setArticleTheme(value: Theme) {
        UserDefaults.standard.set(value.rawValue, forKey: const.articleTheme.rawValue)
    }

}
