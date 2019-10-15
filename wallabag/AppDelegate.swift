//
//  AppDelegate.swift
//  wallabag
//
//  Created by maxime marinel on 19/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import CoreSpotlight
import Crashlytics
import Fabric
import RealmSwift
import Swinject
import UIKit
import UserNotifications
import WallabagCommon

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let container: Container = {
        let container = Container()
        container.register(AnalyticsManager.self) { _ in AnalyticsManager() }.inObjectScope(.container)
        container.register(Realm.self) { _ in
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
        container.register(ThemeManager.self) { _ in
            ThemeManager(currentTheme: White())
        }.inObjectScope(.container)
        container.register(WallabagSetting.self) { _ in WallabagSetting() }.inObjectScope(.container)
        container.register(ArticlePlayer.self) { resolver in
            let articlePlayer = ArticlePlayer()
            articlePlayer.analytics = resolver.resolve(AnalyticsManager.self)
            articlePlayer.setting = resolver.resolve(WallabagSetting.self)
            return articlePlayer
        }.inObjectScope(.container)
        /* container.register(MazouteSDK.self) { _ in
             guard let baseURL = AppDelegate.infoForKey("API_URL"),
                 let username = AppDelegate.infoForKey("API_USERNAME"),
                 let password = AppDelegate.infoForKey("API_PASSWORD") else { fatalError() }
             return MazouteSDK(baseURL: baseURL, username: username, password: password)
         } */

        return container
    }()

    var window: UIWindow?
    var setting: WallabagSetting!
    @Injector var realm: Realm

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])

        handleArgs()

        // setupQuickAction()
        // requestBadge()

        sendUsageVersion()

        return true
    }

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func applicationDidFinishLaunching(_: UIApplication) {
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }

    private func sendUsageVersion() {
        /* WallabagKit.getVersion(from: setting.get(for: .host)) { version in
             Answers.logCustomEvent(withName: "Server version", customAttributes: ["server_version": version.version])
         } */
    }

    private func handleArgs() {
        let args = ProcessInfo.processInfo.arguments
        if args.contains("-reset") {
            resetApplication()
        }
    }

    func application(_: UIApplication, continue userActivity: NSUserActivity, restorationHandler _: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        /* guard
             let mainController = window?.rootViewController! as? UINavigationController,
             let articlesTable = mainController.viewControllers.first as? ArticlesTableViewController else {
             return false
         }
         articlesTable.restoreUserActivityState(userActivity) */
        return true
    }

    func applicationWillEnterForeground(_: UIApplication) {
        // Refresh token quick fix
        /* if Setting.isWallabagConfigured(),
         let host = Setting.getHost(),
         let clientId = Setting.getClientId(),
         let clientSecret = Setting.getClientSecret(),
         let username = Setting.getUsername(),
         let password = Setting.getPassword(username: username) {
         let kit = WallabagKit(host: host, clientID: clientId, clientSecret: clientSecret)
         kit.requestAuth(username: username, password: password) { auth in
         switch auth {
         case .success(let data):
         Setting.set(token: data.accessToken)
         Setting.set(refreshToken: data.refreshToken)
         case .error, .invalidParameter, .unexpectedError:
         break
         }

         }
         } */
    }

    func applicationDidEnterBackground(_: UIApplication) {
        // updateBadge()
    }

    func applicationWillTerminate(_: UIApplication) {
        // updateBadge()
    }

    func application(_: UIApplication, performFetchWithCompletionHandler _: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        /* if Setting.isWallabagConfigured() {
         ArticleSync.sharedInstance.sync { state in
         if state == .finished {
         self.updateBadge()
         completionHandler(.newData)
         }
         }
         } else {
         completionHandler(.noData)
         } */
    }

    /* private func requestBadge() {
         if setting.get(for: .badgeEnabled) {
             UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
         }
     } */

    /* private func updateBadge() {
         if !setting.get(for: .badgeEnabled) {
             UIApplication.shared.applicationIconBadgeNumber = 0
             return
         }

         guard let mode = RetrieveMode(rawValue: setting.get(for: .defaultMode)) else {
             Log("Erreur retrieve mode")
             return
         }
         let entries = try? Realm().objects(Entry.self).filter(mode.predicate())
         UIApplication.shared.applicationIconBadgeNumber = entries?.count ?? 0
     } */

    /*
     private func setupQuickAction() {
         if setting.get(for: .wallabagIsConfigured) {
             let starredAction = UIApplicationShortcutItem(type: RetrieveMode.starredArticles.rawValue, localizedTitle: RetrieveMode.starredArticles.humainReadable().localized, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "starred"), userInfo: [:])
             let unarchivedAction = UIApplicationShortcutItem(
                 type: RetrieveMode.unarchivedArticles.rawValue,
                 localizedTitle: RetrieveMode.unarchivedArticles.humainReadable().localized,
                 localizedSubtitle: nil,
                 icon: UIApplicationShortcutIcon(templateImageName: "unreaded"),
                 userInfo: [:]
             )
             let archivedAction = UIApplicationShortcutItem(type: RetrieveMode.archivedArticles.rawValue, localizedTitle: RetrieveMode.archivedArticles.humainReadable().localized, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "readed"), userInfo: [:])
             UIApplication.shared.shortcutItems = [unarchivedAction, archivedAction, starredAction]
         }
     }*/

    func application(_: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler _: @escaping (Bool) -> Void) {
        /* guard let navController = window!.rootViewController as? UINavigationController,
             let rootController = navController.viewControllers.first as? ArticlesTableViewController else {
             return
         }
         if let mode = RetrieveMode(rawValue: shortcutItem.type) {
             rootController.mode = mode
         }*/
    }

    func resetApplication() {
        // setting.reset(suiteName: setting.sharedDomain)
        try? realm.write {
            realm.deleteAll()
        }
    }
}
