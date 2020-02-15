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
import Swinject
import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let container: Container = {
        let container = Container()
        container.register(AnalyticsManager.self) { _ in AnalyticsManager() }.inObjectScope(.container)
        container.register(WallabagKit.self, factory: { _ in WallabagKit(host: WallabagUserDefaults.host) }).inObjectScope(.container)
        container.register(WallabagSession.self, factory: { _ in WallabagSession() })
        container.register(ArticlePlayer.self) { resolver in
            let articlePlayer = ArticlePlayer()
            articlePlayer.analytics = resolver.resolve(AnalyticsManager.self)
            return articlePlayer
        }.inObjectScope(.container)
        container.register(ImageDownloader.self, factory: { _ in ImageDownloader.shared }).inObjectScope(.container)
        container.register(AppState.self, factory: { _ in AppState() }).inObjectScope(.container)
        container.register(Router.self, factory: { _ in Router() }).inObjectScope(.container)
        container.register(PlayerPublisher.self, factory: { _ in PlayerPublisher() }).inObjectScope(.container)

        return container
    }()

    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])

        requestBadge()

        return true
    }

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func applicationDidFinishLaunching(_: UIApplication) {
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }

    private func requestBadge() {
        if WallabagUserDefaults.badgeEnabled {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
        }
    }
}
