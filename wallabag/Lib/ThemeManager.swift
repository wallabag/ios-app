//
//  ThemeManager.swift
//  wallabag
//
//  Created by maxime marinel on 14/12/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

struct ThemeManager {

    // Add theme here and dont forget add in allThemes
    enum Theme: String {
        case white
        case light
        case dusk
        case night

        static let allThemes: [Theme] = [white, light, dusk, night]

        // color for the menu and listing articles
        var color: UIColor {
            switch self {
            case .light:
                // #404040
                return UIColor.init(red: 64.rgb, green: 64.rgb, blue: 64.rgb, alpha: 1)
            case .dusk:
                // #a0a0a0
                return UIColor.init(red: 160.rgb, green: 160.rgb, blue: 160.rgb, alpha: 1)
            case .night:
                // #999999
                return UIColor.init(red: 153.rgb, green: 153.rgb, blue: 153.rgb, alpha: 1)
            default:
                return UIColor.black
            }
        }

        // color for navigation button (back, delete, star, share)
        var tintColor: UIColor {
            switch self {
            case .light:
                return UIColor.init(red: 64.rgb, green: 64.rgb, blue: 64.rgb, alpha: 1)
            case .dusk:
                return UIColor.init(red: 160.rgb, green: 160.rgb, blue: 160.rgb, alpha: 1)
            case .night:
                return UIColor.init(red: 153.rgb, green: 153.rgb, blue: 153.rgb, alpha: 1)
            default:
                return UIColor.black
            }
        }

        var barStyle: UIBarStyle {
            switch self {
            case .night:
                return .black
            default:
                return .default
            }
        }

        // background of the article (outside the webview) & the listing
        var backgroundColor: UIColor {
            switch self {
            case .light:
                // #f6efdc
                return UIColor.init(red: 246.rgb, green: 239.rgb, blue: 220.rgb, alpha: 1)
            case .dusk:
                // #3c3c3c
                return UIColor.init(red: 60.rgb, green: 60.rgb, blue: 60.rgb, alpha: 1)
            case .night:
                // #222222
                return UIColor.init(red: 34.rgb, green: 34.rgb, blue: 34.rgb, alpha: 1)
            default:
                return UIColor.white
            }
        }

        var navigationBarBackground: UIImage? {
            switch self {
            case .light:
                let image = #imageLiteral(resourceName: "navBackgroundSoft")
                return image
            case .dusk:
                let image = #imageLiteral(resourceName: "navBackgroundDusk")
                return image
            case .night:
                let image = #imageLiteral(resourceName: "navBackgroundNight")
                return image
            default:
                return nil
            }
        }

        // background color when an element is selected in the list
        var backgroundSelectedColor: UIColor {
            switch self {
            case .light:
                // #ddd7c6
                return UIColor.init(red: 221.rgb, green: 215.rgb, blue: 198.rgb, alpha: 1)
            case .dusk:
                // #4f4f4f
                return UIColor.init(red: 79.rgb, green: 79.rgb, blue: 79.rgb, alpha: 1)
            case .night:
                // #383838
                return UIColor.init(red: 56.rgb, green: 56.rgb, blue: 56.rgb, alpha: 1)
            default:
                // e5e5e5
                return UIColor.init(red: 229.rgb, green: 229.rgb, blue: 229.rgb, alpha: 1)
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
        bar.titleTextAttributes = [NSForegroundColorAttributeName: theme.color]
        bar.barStyle = theme.barStyle

        let toolbar = UIToolbar.appearance()
        toolbar.setBackgroundImage(theme.navigationBarBackground, forToolbarPosition: .any, barMetrics: .default)

        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSFontAttributeName: UIFont(name: "UbuntuTitling-Bold", size: 15.0)!
            ], for: .normal)

        NotificationCenter.default.post(name: Notification.Name.themeUpdated, object: nil)
    }
}

extension Notification.Name {
    static var themeUpdated: Notification.Name {
        return Notification.Name(rawValue: "theme.updted")
    }
}
