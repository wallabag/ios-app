//
//  Setting.swift
//  wallabag
//
//  Created by maxime marinel on 23/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import Foundation

class Setting {

    fileprivate enum const: String {
        case defaultMode
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
}
