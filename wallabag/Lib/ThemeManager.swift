//
//  ThemeManager.swift
//  wallabag
//
//  Created by maxime marinel on 14/12/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

struct ThemeManager {

    enum Theme: String {
        case light
        case night

        static let allThemes: [Theme] = [light, night]

        var color: UIColor {
            switch self {
            case .night:
                return UIColor.red
            default:
                return UIColor.black
            }
        }
    }

    static func apply(theme: Theme) {
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.color

        let uiButton = UIButton.appearance()
        uiButton.tintColor = theme.color

        let uiLabel = UILabel.appearance()
        uiLabel.textColor = theme.color
    }
}
