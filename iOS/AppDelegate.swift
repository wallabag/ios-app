#if os(iOS)
import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
            let args = ProcessInfo.processInfo.arguments

            if args.contains("POPULATE_APPLICATION") {
                populateApplication()
            }
        #endif

        return true
    }

    func applicationDidFinishLaunching(_: UIApplication) {
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }

    func applicationWillTerminate(_: UIApplication) {}
}
#endif
