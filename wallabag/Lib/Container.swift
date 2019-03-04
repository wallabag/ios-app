//
//  Container.swift
//  wallabag
//
//  Created by maxime marinel on 27/02/2019.
//

import Foundation
import Swinject
import SwinjectStoryboard
import WallabagCommon
import RealmSwift

extension SwinjectStoryboard {
    @objc class func setup() {
        defaultContainer.register(WallabagSetting.self) { _ in WallabagSetting() }.inObjectScope(.container)
        defaultContainer.register(AnalyticsManager.self) { _ in AnalyticsManager() }.inObjectScope(.container)
        defaultContainer.register(Realm.self) { _ in
            do {
                let config = Realm.Configuration(
                    schemaVersion: 2,
                    migrationBlock: { _, _ in
                })

                Realm.Configuration.defaultConfiguration = config

                return try Realm()
            } catch let error {
                print(error)
                fatalError("Error init realm")
            }
        }.inObjectScope(.container)
        defaultContainer.register(ThemeManager.self) { _ in
            return ThemeManager(currentTheme: White())
        }.inObjectScope(.container)
        defaultContainer.storyboardInitCompleted(AboutViewController.self) { resolver, controller in
            controller.analytics = resolver.resolve(AnalyticsManager.self)
            controller.themeManager = resolver.resolve(ThemeManager.self)
        }
        defaultContainer.storyboardInitCompleted(ArticleViewController.self) { resolver, controller in
            controller.analytics = resolver.resolve(AnalyticsManager.self)
            controller.themeManager = resolver.resolve(ThemeManager.self)
        }
        defaultContainer.storyboardInitCompleted(ArticlesTableViewController.self) { resolver, controller in
            controller.analytics = resolver.resolve(AnalyticsManager.self)
            controller.setting = resolver.resolve(WallabagSetting.self)
            controller.hapticNotification = UINotificationFeedbackGenerator()
            controller.realm = resolver.resolve(Realm.self)
        }
        defaultContainer.storyboardInitCompleted(ClientIdViewController.self) { resolver, controller in
            controller.analytics = resolver.resolve(AnalyticsManager.self)
            controller.setting = resolver.resolve(WallabagSetting.self)
        }
        defaultContainer.storyboardInitCompleted(HomeViewController.self) { resolver, controller in
            controller.analytics = resolver.resolve(AnalyticsManager.self)
            controller.setting = resolver.resolve(WallabagSetting.self)
        }
        defaultContainer.storyboardInitCompleted(LoginViewController.self) { resolver, controller in
            controller.analytics = resolver.resolve(AnalyticsManager.self)
            controller.setting = resolver.resolve(WallabagSetting.self)
        }
        defaultContainer.storyboardInitCompleted(ServerViewController.self) { resolver, controller in
            controller.analytics = resolver.resolve(AnalyticsManager.self)
            controller.setting = resolver.resolve(WallabagSetting.self)
        }
        defaultContainer.storyboardInitCompleted(SettingsTableViewController.self) { resolver, controller in
            controller.analytics = resolver.resolve(AnalyticsManager.self)
            controller.setting = resolver.resolve(WallabagSetting.self)
            controller.themeManager = resolver.resolve(ThemeManager.self)
        }
        defaultContainer.storyboardInitCompleted(ThemeChoiceTableViewController.self) { resolver, controller in
            controller.analytics = resolver.resolve(AnalyticsManager.self)
            controller.setting = resolver.resolve(WallabagSetting.self)
            controller.themeManager = resolver.resolve(ThemeManager.self)
        }
        defaultContainer.storyboardInitCompleted(TipViewController.self) { resolver, controller in
            controller.analytics = resolver.resolve(AnalyticsManager.self)
            controller.themeManager = resolver.resolve(ThemeManager.self
            )
        }
        defaultContainer.storyboardInitCompleted(VoiceChoiceTableViewController.self) { resolver, controller in
            controller.analytics = resolver.resolve(AnalyticsManager.self)
            controller.setting = resolver.resolve(WallabagSetting.self)
        }
        defaultContainer.storyboardInitCompleted(UINavigationController.self) { _, _ in }
    }
}
