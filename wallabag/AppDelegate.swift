//
//  AppDelegate.swift
//  wallabag
//
//  Created by maxime marinel on 19/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityIndicator
import CoreSpotlight
import UserNotifications
import RealmSwift
import WallabagCommon
import WallabagKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let setting: WallabagSetting = WallabagSetting()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])

        configureTheme()
        configureNetworkIndicator()
        configureGA()
        configureRealm()
        handleArgs()

        Log(WallabagSession.shared.currentState)

        guard WallabagSession.shared.currentState != .missingConfiguration  else {
            let homeController = window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "home") as? HomeViewController
            window?.rootViewController = homeController
            return true
        }

        WallabagSession.shared.startSession()
        setupQuickAction()
        requestBadge()

        sendUsageVersion()

        return true
    }

    private func sendUsageVersion() {
        WallabagKit.getVersion(from: setting.get(for: .host)) { version in
            Answers.logCustomEvent(withName: "Server version", customAttributes: ["server_version": version.version])
        }
    }

    private func configureTheme() {
        ThemeManager.manager.apply(setting.get(for: .theme))
    }

    private func handleArgs() {
        let args = ProcessInfo.processInfo.arguments
        if args.contains("-reset") {
            resetApplication()
        }
    }

    private func configureGA() {
        let gai = GAI.sharedInstance()
        _ = gai?.tracker(withTrackingId: "UA-115437094-1")
        gai?.trackUncaughtExceptions = true
    }

    private func configureRealm() {
        Log("[LOG] Realm path" + (Realm.Configuration.defaultConfiguration.fileURL?.description)!)
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { _, _ in
        })

        Realm.Configuration.defaultConfiguration = config

        do {
            _ = try Realm()
        } catch {
            fatalError("real error")
        }
    }

    private func configureNetworkIndicator() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
        NetworkActivityIndicatorManager.shared.startDelay = 0.1
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard
            let mainController = window?.rootViewController! as? UINavigationController,
            let articlesTable = mainController.viewControllers.first as? ArticlesTableViewController else {
                return false
        }
        articlesTable.restoreUserActivityState(userActivity)
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        //Refresh token quick fix
        /*if Setting.isWallabagConfigured(),
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
         }*/
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        updateBadge()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        updateBadge()
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        /*if Setting.isWallabagConfigured() {
         ArticleSync.sharedInstance.sync { state in
         if state == .finished {
         self.updateBadge()
         completionHandler(.newData)
         }
         }
         } else {
         completionHandler(.noData)
         }*/
    }

    private func requestBadge() {
        if setting.get(for: .badgeEnabled) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
        }
    }

    private func updateBadge() {
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
    }

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
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        guard let navController = window!.rootViewController as? UINavigationController,
            let rootController = navController.viewControllers.first as? ArticlesTableViewController else {
                return
        }
        if let mode = RetrieveMode(rawValue: shortcutItem.type) {
            rootController.mode = mode
        }
    }

    func resetApplication() {
        setting.reset(suiteName: setting.sharedDomain)
        try? Realm().write {
            try? Realm().deleteAll()
        }
    }
}
