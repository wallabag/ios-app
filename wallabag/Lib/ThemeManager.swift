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
        case night
        case light

        static let allThemes: [Theme] = [white, light, night]

        // color for the menu and listing articles
        var color: UIColor {
            switch self {
            case .night:
                return UIColor.init(red: 153, green: 153, blue: 153, alpha: 1)
            case .light:
                //return UIColor.init(red: 64, green: 64, blue: 64, alpha: 1)
                return UIColor.green
            default:
                return UIColor.black
            }
        }

        // color for navigation button (back, delete, star, share)
        var tintColor: UIColor {
            switch self {
            case .night:
                return UIColor.init(red: 153, green: 153, blue: 153, alpha: 1)
            case .light:
                return UIColor.init(red: 64, green: 64, blue: 64, alpha: 1)
            default:
                return UIColor.black
            }
        }

        // background of the article (outside the webview) & the listing
        var backgroundColor: UIColor {
            switch self {
            case .night:
                return UIColor.init(red: 17, green: 17, blue: 17, alpha: 1)
            case .light:
                return UIColor.init(red: 246, green: 239, blue: 220, alpha: 1)
            default:
                return UIColor.white
            }
        }

        var navigationBarBackground: UIImage? {
            switch self {
            case .night:
                let image = #imageLiteral(resourceName: "navBackgroundNight")
                return image
            case .light:
                let image = #imageLiteral(resourceName: "navBackgroundSoft")
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
