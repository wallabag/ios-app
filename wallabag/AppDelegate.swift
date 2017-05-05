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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let args = ProcessInfo.processInfo.arguments
        if args.contains("RESET_APPLICATION") {
            resetApplication()
        }

        WallabagApi.init(userStorage: UserDefaults(suiteName: "group.wallabag.share_extension")!)

        if !WallabagApi.isConfigured() {
            window?.rootViewController = window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "home")
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
        if WallabagApi.isConfigured() {
            updateBadge()
            completionHandler(.newData)
        } else {
            completionHandler(.noData)
        }
    }

    private func requestBadge() {
        if Setting.isBadgeEnable() {
            UIApplication.shared.setMinimumBackgroundFetchInterval(3600.0)
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }

    private func updateBadge() {
        if WallabagApi.isConfigured() {
            WallabagApi.retrieveUnreadArticle { total in
                UIApplication.shared.applicationIconBadgeNumber = total
            }
        }
    }

    func resetApplication() {
        Setting.deleteServer()
        Setting.setTheme(value: .white)
        Setting.setDefaultMode(mode: .allArticles)
    }
}
