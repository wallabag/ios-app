import Factory
import Foundation
import os
import SharedLib
import SwiftUI

let logger = Logger(subsystem: "fr.district-web.wallabag", category: "main")

@main
struct WallabagApp: App {
    @Environment(\.scenePhase) var scenePhase
    #if os(iOS)
        @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    #endif

    @State private var router = Container.shared.router()
    @State private var appSync = Container.shared.appSync()
    @State private var wallabagPlusStore = Container.shared.wallabagPlusStore()
    @State private var errorHandler = Container.shared.errorHandler()

    @InjectedObject(\.appState) private var appState
    #if os(iOS)
        @State private var playerPublisher = Container.shared.playerPublisher()
    #endif
    @InjectedObject(\.appSetting) private var appSetting
    @Injected(\.coreDataSync) private var coreDataSync
    @Injected(\.coreData) private var coreData

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appState)
            #if os(iOS)
                .environment(playerPublisher)
            #endif
                .environment(router)
                .environment(appSync)
                .environment(wallabagPlusStore)
                .environment(errorHandler)
                .environmentObject(appSetting)
                .environment(\.managedObjectContext, coreData.viewContext)
        }
        .onChange(of: scenePhase) { _, newScenePhase in
            if newScenePhase == .active {
                Task {
                    await appState.initSession()
                    await wallabagPlusStore.checkPro()
                }
                #if os(iOS)
                    requestNotificationAuthorization()
                #endif
            }

            if newScenePhase == .background {
                coreData.saveContext()
                updateBadge()
            }
        }
        .commands {
            CommandGroup(after: .newItem) {
                Button("Refresh entries") {
                    appSync.requestSync()
                }
                .keyboardShortcut("r", modifiers: .command)
            }
        }
    }

    private func updateBadge() {
        if !WallabagUserDefaults.badgeEnabled {
            setBadgeNumber(0)
            return
        }

        do {
            let fetchRequest = Entry.fetchRequestSorted()
            fetchRequest.predicate = RetrieveMode(fromCase: WallabagUserDefaults.defaultMode).predicate()
            let entries = try coreData.viewContext.fetch(fetchRequest)
            setBadgeNumber(entries.count)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func setBadgeNumber(_ number: Int) {
        Task {
            try? await UNUserNotificationCenter.current().setBadgeCount(number)
        }
    }

    #if os(iOS)
        private func requestNotificationAuthorization() {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge]) { _, _ in }
        }
    #endif
}
