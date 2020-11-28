import Foundation
import SwiftUI

@main
struct WallabagApp: App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var appState = AppState.shared
    var router = Router.shared
    var playerPublisher = PlayerPublisher.shared
    var errorViewModel = ErrorViewModel.shared
    var appSync = AppSync.shared
    let coreDataSync = CoreDataSync()
    let appSetting = AppSetting()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appState)
                .environmentObject(playerPublisher)
                .environmentObject(router)
                .environmentObject(errorViewModel)
                .environmentObject(appSync)
                .environmentObject(appSetting)
                .environment(\.managedObjectContext, CoreData.shared.viewContext)
        }.onChange(of: scenePhase) { state in
            if state == .active {
                appState.initSession()
            }

            if state == .background {
                CoreData.shared.saveContext()
                updateBadge()
            }
        }
    }

    private func updateBadge() {
        if !WallabagUserDefaults.badgeEnabled {
            UIApplication.shared.applicationIconBadgeNumber = 0
            return
        }

        do {
            let fetchRequest = Entry.fetchRequestSorted()
            fetchRequest.predicate = RetrieveMode(fromCase: WallabagUserDefaults.defaultMode).predicate()
            let entries = try CoreData.shared.viewContext.fetch(fetchRequest)
            UIApplication.shared.applicationIconBadgeNumber = entries.count
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
