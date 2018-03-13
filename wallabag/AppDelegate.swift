//
//  AppDelegate.swift
//  wallabag
//
//  Created by maxime marinel on 19/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import WallabagKit
import AlamofireNetworkActivityIndicator
import CoreSpotlight
import UserNotifications
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        print("[LOG] Realm path" + (Realm.Configuration.defaultConfiguration.fileURL?.description)!)

        let gai = GAI.sharedInstance()
        gai?.tracker(withTrackingId: "UA-115437094-1")
        gai?.trackUncaughtExceptions = true

        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
        })

        Realm.Configuration.defaultConfiguration = config

        do {
            _ = try Realm()
        } catch {
            fatalError("real error")
        }

        let args = ProcessInfo.processInfo.arguments
        if args.contains("RESET_APPLICATION") {
            resetApplication()
        }

        if Setting.isWallabagConfigured() {
            NSLog("Wallabag api is configured")
            window?.rootViewController = window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "articlesNavigation")
            UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
            requestBadge()
        }

        NetworkActivityIndicatorManager.shared.isEnabled = true
        NetworkActivityIndicatorManager.shared.startDelay = 0.1

        ThemeManager.manager.apply(Setting.getTheme())

        setupQuickAction()

        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        guard Setting.isWallabagConfigured(),
            let mainController = window?.rootViewController! as? UINavigationController,
            let articlesTable = mainController.viewControllers.first as? ArticlesTableViewController else {
                return false
        }
        articlesTable.restoreUserActivityState(userActivity)
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        updateBadge()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        updateBadge()
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        if Setting.isWallabagConfigured() {
            ArticleSync.sharedInstance.sync { state in
                if state == .finished {
                    self.updateBadge()
                    completionHandler(.newData)
                }
            }
        } else {
            completionHandler(.noData)
        }
    }

    private func requestBadge() {
        if Setting.isBadgeEnable() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
        }
    }

    private func updateBadge() {
        if !Setting.isBadgeEnable() {
            UIApplication.shared.applicationIconBadgeNumber = 0
            return
        }

        let entries = try? Realm().objects(Entry.self).filter(Setting.getDefaultMode().predicate())
        UIApplication.shared.applicationIconBadgeNumber = entries?.count ?? 0
    }

    private func setupQuickAction() {
        if Setting.isWallabagConfigured() {
            let starredAction = UIApplicationShortcutItem(type: Setting.RetrieveMode.starredArticles.rawValue, localizedTitle: Setting.RetrieveMode.starredArticles.humainReadable().localized, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "starred"), userInfo: [:])
            let unarchivedAction = UIApplicationShortcutItem(
                type: Setting.RetrieveMode.unarchivedArticles.rawValue,
                localizedTitle: Setting.RetrieveMode.unarchivedArticles.humainReadable().localized,
                localizedSubtitle: nil,
                icon: UIApplicationShortcutIcon(templateImageName: "unreaded"),
                userInfo: [:]
            )
            let archivedAction = UIApplicationShortcutItem(type: Setting.RetrieveMode.archivedArticles.rawValue, localizedTitle: Setting.RetrieveMode.archivedArticles.humainReadable().localized, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "readed"), userInfo: [:])
            UIApplication.shared.shortcutItems = [unarchivedAction, archivedAction, starredAction]
        }
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        guard let navController = window!.rootViewController as? UINavigationController,
            let rootController = navController.viewControllers.first as? ArticlesTableViewController else {
                return
        }
        if let mode = Setting.RetrieveMode(rawValue: shortcutItem.type) {
            rootController.mode = mode
        }
    }

    func resetApplication() {
        Setting.purge()
        try? Realm().write {
            try? Realm().deleteAll()
        }
    }
}
