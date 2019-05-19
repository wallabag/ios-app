//
//  Container.swift
//  wallabag
//
//  Created by maxime marinel on 27/02/2019.
//

import Foundation
import RealmSwift
import SideMenu
import Swinject
import SwinjectStoryboard
import WallabagCommon
import WallabagKit

// swiftlint:disable function_body_length
extension SwinjectStoryboard {
    private class func registerClass() {
        defaultContainer.register(AnalyticsManager.self) { _ in AnalyticsManager() }.inObjectScope(.container)
        defaultContainer.register(Realm.self) { _ in
            do {
                let config = Realm.Configuration(
                    schemaVersion: 8,
                    migrationBlock: { _, _ in
                    }
                )

                Realm.Configuration.defaultConfiguration = config
                Log("Realm path: \(Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? "")")
                return try Realm()
            } catch {
                fatalError("Error init realm")
            }
        }.inObjectScope(.container)
        defaultContainer.register(ThemeManager.self) { _ in
            ThemeManager(currentTheme: White())
        }.inObjectScope(.container)
        defaultContainer.register(WallabagSetting.self) { _ in WallabagSetting() }.inObjectScope(.container)
        defaultContainer.register(WallabagSession.self) { resolver in
            guard let setting = resolver.resolve(WallabagSetting.self) else { fatalError() }
            let session = WallabagSession(setting: setting)

            return session
        }.inObjectScope(.container)
    }

    private class func registerStoryboard() {
        defaultContainer.storyboardInitCompleted(AboutViewController.self) { resolver, controller in
            controller.analytics = resolver.resolve(AnalyticsManager.self)
            controller.themeManager = resolver.resolve(ThemeManager.self)
        }
        defaultContainer.storyboardInitCompleted(ArticleViewController.self) { resolver, controller in
            controller.analytics = resolver.resolve(AnalyticsManager.self)
            controller.themeManager = resolver.resolve(ThemeManager.self)
            controller.setting = resolver.resolve(WallabagSetting.self)
            controller.realm = resolver.resolve(Realm.self)
        }
        defaultContainer.storyboardInitCompleted(ArticlesTableViewController.self) { resolver, controller in
            controller.analytics = resolver.resolve(AnalyticsManager.self)
            controller.setting = resolver.resolve(WallabagSetting.self)
            controller.hapticNotification = UINotificationFeedbackGenerator()
            controller.wallabagSync = resolver.resolve(WallabagSyncing.self)
            controller.wallabagSession = resolver.resolve(WallabagSession.self)
            controller.realm = resolver.resolve(Realm.self)
        }
        defaultContainer.storyboardInitCompleted(ArticleTagViewController.self) { resolver, controller in
            controller.realm = resolver.resolve(Realm.self)
            controller.wallabagSession = resolver.resolve(WallabagSession.self)
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
            controller.wallabagSession = resolver.resolve(WallabagSession.self)
        }
        defaultContainer.storyboardInitCompleted(PodcastViewController.self) { resolver, controller in
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
        defaultContainer.storyboardInitCompleted(TagsTableViewController.self) { resolver, controller in
            controller.analytics = resolver.resolve(AnalyticsManager.self)
            controller.setting = resolver.resolve(WallabagSetting.self)
            controller.realm = resolver.resolve(Realm.self)
        }
        defaultContainer.storyboardInitCompleted(ThemeChoiceTableViewController.self) { resolver, controller in
            controller.analytics = resolver.resolve(AnalyticsManager.self)
            controller.setting = resolver.resolve(WallabagSetting.self)
            controller.themeManager = resolver.resolve(ThemeManager.self)
        }
        defaultContainer.storyboardInitCompleted(TipViewController.self) { resolver, controller in
            controller.analytics = resolver.resolve(AnalyticsManager.self)
            controller.themeManager = resolver.resolve(ThemeManager.self)
        }
        defaultContainer.storyboardInitCompleted(VoiceChoiceTableViewController.self) { resolver, controller in
            controller.analytics = resolver.resolve(AnalyticsManager.self)
            controller.setting = resolver.resolve(WallabagSetting.self)
        }

        defaultContainer.storyboardInitCompleted(UINavigationController.self) { _, _ in }
        defaultContainer.storyboardInitCompleted(UITableViewController.self) { _, _ in }
        defaultContainer.storyboardInitCompleted(UISideMenuNavigationController.self) { _, _ in }
    }

    @objc class func setup() {
        registerClass()
        registerStoryboard()
    }
}
