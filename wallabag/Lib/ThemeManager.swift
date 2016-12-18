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
                return UIColor.black
            default:
                return UIColor.black
            }
        }

        var tintColor: UIColor {
            switch self {
            case .night:
                return UIColor.black
            default:
                return UIColor.black
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case .night:
                return UIColor.gray
            default:
                return UIColor.clear
            }
        }

        var navigationBarBackground: UIImage? {
            switch self {
            case .night:
                let image = #imageLiteral(resourceName: "navBackgroundNight")
                return image
            default:
                return nil
            }
        }
    }

    static func apply(theme: Theme) {
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.tintColor

        let uiButton = UIButton.appearance()
        uiButton.tintColor = theme.tintColor

        let uiBarButton = UIBarButtonItem.appearance()
        uiBarButton.tintColor = theme.tintColor

        let uiLabel = UILabel.appearance()
        uiLabel.textColor = theme.color

        let bar = UINavigationBar.appearance()
        bar.setBackgroundImage(theme.navigationBarBackground, for: .default)

        let toolbar = UIToolbar.appearance()
        toolbar.setBackgroundImage(theme.navigationBarBackground, forToolbarPosition: .any, barMetrics: .default)

        NotificationCenter.default.post(name: Notification.Name.themeUpdated, object: nil)
    }
}

extension Notification.Name {
    static var themeUpdated: Notification.Name {
        return Notification.Name(rawValue: "theme.updted")
    }
}
