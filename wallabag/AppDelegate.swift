//
//  AppDelegate.swift
//  wallabag
//
//  Created by maxime marinel on 19/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import AlamofireNetworkActivityIndicator
import CoreSpotlight
import Crashlytics
import Fabric
import RealmSwift
import SwinjectStoryboard
import UIKit
import UserNotifications
import WallabagCommon
import WallabagKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var setting: WallabagSetting!
    var wallabagSession: WallabagSession!
    var realm: Realm!

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])

        setting = SwinjectStoryboard.defaultContainer.resolve(WallabagSetting.self)
        realm = SwinjectStoryboard.defaultContainer.resolve(Realm.self)
        wallabagSession = SwinjectStoryboard.defaultContainer.resolve(WallabagSession.self)

        configureTheme()
        configureNetworkIndicator()
        handleArgs()

        Log(wallabagSession.currentState)

        guard wallabagSession.currentState != .missingConfiguration else {
            let homeController = window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "home") as? HomeViewController
            window?.rootViewController = homeController
            return true
        }

        wallabagSession.startSession()
        setupQuickAction()
        requestBadge()

        sendUsageVersion()

        return true
    }

    private func sendUsageVersion() {
        SwinjectStoryboard.defaultContainer.resolve(WallabagKit.self)?.request(endpoint: VersionEndpoint.getVersion) {
            response in
            switch response.result {
            case let .success(version):
                Answers.logCustomEvent(withName: "Server version", customAttributes: ["server_version": version])
            default:
                break
            }
        }

    }

    private func configureTheme() {
        let theme = setting.get(for: .theme)
        SwinjectStoryboard.defaultContainer.resolve(ThemeManager.self)?.apply(theme)
        Answers.logCustomEvent(withName: "Theme", customAttributes: ["theme": theme])
    }

    private func handleArgs() {
        let args = ProcessInfo.processInfo.arguments
        if args.contains("-reset") {
            resetApplication()
        }
    }

    private func configureNetworkIndicator() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
        NetworkActivityIndicatorManager.shared.startDelay = 0.1
    }

    func application(_: UIApplication, continue userActivity: NSUserActivity, restorationHandler _: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard
            let mainController = window?.rootViewController! as? UINavigationController,
            let articlesTable = mainController.viewControllers.first as? ArticlesTableViewController else {
            return false
        }
        articlesTable.restoreUserActivityState(userActivity)
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
        updateBadge()
    }

    func applicationWillTerminate(_: UIApplication) {
        updateBadge()
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

    func application(_: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler _: @escaping (Bool) -> Void) {
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
        try? realm.write {
            realm.deleteAll()
        }
    }
}
