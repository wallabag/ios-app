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

    @Injected(\.appState) private var appState
    @Injected(\.router) private var router
    #if os(iOS)
        @Injected(\.playerPublisher) private var playerPublisher
    #endif
    @Injected(\.errorHandler) private var errorHandler
    @Injected(\.appSync) private var appSync
    @Injected(\.coreDataSync) private var coreDataSync
    @Injected(\.appSetting) private var appSetting
    @Injected(\.coreData) private var coreData

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(appState)
            #if os(iOS)
                .environmentObject(playerPublisher)
            #endif
                .environmentObject(router)
                .environmentObject(errorHandler)
                .environmentObject(appSync)
                .environmentObject(appSetting)
                .environment(\.managedObjectContext, coreData.viewContext)
        }.onChange(of: scenePhase) { state in
            if state == .active {
                appState.initSession()
                #if os(iOS)
                    requestNotificationAuthorization()
                #endif
            }

            if state == .background {
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
        #if os(iOS)
            UIApplication.shared.applicationIconBadgeNumber = number
        #endif
    }

    #if os(iOS)
        private func requestNotificationAuthorization() {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge]) { _, _ in }
        }
    #endif
}
