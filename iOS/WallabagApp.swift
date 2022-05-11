import Foundation
import os
import SharedLib
import SwiftUI

let logger = Logger(subsystem: "fr.district-web.wallabag", category: "main")

@main
struct WallabagApp: App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    let appState: AppState = DependencyInjection.container.resolve(AppState.self)!
    let router: Router = DependencyInjection.container.resolve(Router.self)!
    let playerPublisher: PlayerPublisher = DependencyInjection.container.resolve(PlayerPublisher.self)!
    let errorViewModel: ErrorViewModel = DependencyInjection.container.resolve(ErrorViewModel.self)!
    let appSync: AppSync = DependencyInjection.container.resolve(AppSync.self)!
    let coreDataSync: CoreDataSync = DependencyInjection.container.resolve(CoreDataSync.self)!
    let appSetting: AppSetting = DependencyInjection.container.resolve(AppSetting.self)!
    let coreData: CoreData = DependencyInjection.container.resolve(CoreData.self)!

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appState)
                .environmentObject(playerPublisher)
                .environmentObject(router)
                .environmentObject(errorViewModel)
                .environmentObject(appSync)
                .environmentObject(appSetting)
                .environment(\.managedObjectContext, coreData.viewContext)
        }.onChange(of: scenePhase) { state in
            if state == .active {
                appState.initSession()
            }

            if state == .background {
                coreData.saveContext()
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
            let entries = try coreData.viewContext.fetch(fetchRequest)
            UIApplication.shared.applicationIconBadgeNumber = entries.count
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
