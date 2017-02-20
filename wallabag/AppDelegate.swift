//
//  AppDelegate.swift
//  wallabag
//
//  Created by maxime marinel on 19/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityIndicator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let args = ProcessInfo.processInfo.arguments
        if args.contains("RESET_APPLICATION") {
            Setting.deleteServer()
            Setting.setTheme(value: .white)
            Setting.setDefaultMode(mode: .allArticles)
        }

        requestBadge()
        updateBadge()

        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSFontAttributeName: UIFont(name: "UbuntuTitling-Bold", size: 15.0)!
            ], for: .normal)

        NetworkActivityIndicatorManager.shared.isEnabled = true
        NetworkActivityIndicatorManager.shared.startDelay = 0.1

        WallabagApi.mode = Setting.getDefaultMode()

        ThemeManager.apply(theme: Setting.getTheme())

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        updateBadge()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        updateBadge()
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        if nil != Setting.getServer() && Setting.isBadgeEnable() {
            updateBadge()
            completionHandler(.newData)
        } else {
            completionHandler(.noData)
        }
    }

    private func requestBadge() {
        if Setting.isBadgeEnable() {
            UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        } else {

        }
    }

    private func updateBadge() {
        guard let server = Setting.getServer(), Setting.isBadgeEnable() else {
            UIApplication.shared.applicationIconBadgeNumber = 0
            return
        }

        WallabagApi.configureApi(from: server)
        WallabagApi.requestToken { _ in
            WallabagApi.retrieveUnreadArticle { total in
                UIApplication.shared.applicationIconBadgeNumber = total
            }
        }

    }
}
