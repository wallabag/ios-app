import CoreSpotlight
import MetricKit
import Swinject
import UIKit
import UserNotifications
import WallabagKit

extension AppDelegate: MXMetricManagerSubscriber {
    func didReceive(_: [MXMetricPayload]) {}
}

final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        MXMetricManager.shared.add(self)
        #if DEBUG
            let args = ProcessInfo.processInfo.arguments

            if args.contains("POPULATE_APPLICATION") {
                populateApplication()
            }
        #endif

        requestBadge()

        return true
    }

    func applicationDidFinishLaunching(_: UIApplication) {
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }

    func applicationWillTerminate(_: UIApplication) {
        MXMetricManager.shared.remove(self)
    }

    private func requestBadge() {
        if WallabagUserDefaults.badgeEnabled {
            // UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
        }
    }
}
