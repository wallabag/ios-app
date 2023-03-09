import Factory
import Foundation
import os
import SharedLib
import SwiftUI

let logger = Logger(subsystem: "fr.district-web.wallabag", category: "main")

@main
struct WallabagApp: App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    @Injected(\.appState) private var appState
    @Injected(\.router) private var router
    @Injected(\.playerPublisher) private var playerPublisher
    @Injected(\.errorHandler) private var errorHandler
    @Injected(\.appSync) private var appSync
    @Injected(\.coreDataSync) private var coreDataSync
    @Injected(\.appSetting) private var appSetting
    @Injected(\.coreData) private var coreData

    var body: some Scene {
        WindowGroup {
            Main2View()
                .environmentObject(appState)
                .environmentObject(playerPublisher)
                .environmentObject(router)
                .environmentObject(errorHandler)
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
