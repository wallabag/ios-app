//
//  WallabagApp.swift
//  wallabag
//
//  Created by Marinel Maxime on 25/06/2020.
//

import Combine
import SwiftUI

final class BadgeService {
    private var cancellables = Set<AnyCancellable>()
    init() {
        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink(receiveValue: didEnterBackgroundNotification(_:))
            .store(in: &cancellables)

        if WallabagUserDefaults.badgeEnabled {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) { _, _ in }
        }
    }

    private func didEnterBackgroundNotification(_: Notification) {
        if !WallabagUserDefaults.badgeEnabled {
            UIApplication.shared.applicationIconBadgeNumber = 0
            return
        }

        do {
            let fetchRequest = Entry.fetchRequestSorted()
            fetchRequest.predicate = RetrieveMode(fromCase: WallabagUserDefaults.defaultMode).predicate()
            let entries = try CoreData.shared.viewContext.count(for: fetchRequest)
            UIApplication.shared.applicationIconBadgeNumber = entries
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

@main
struct WallabagApp: App {
    let coreDataSync = CoreDataSync()
    private var badgeService = BadgeService()
    @StateObject var appSetting = AppSetting()

    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(AppDelegate.container.resolve(AppState.self)!)
                // .environmentObject(playerPublisher)
                .environmentObject(AppDelegate.container.resolve(Router.self)!)
                .environmentObject(AppDelegate.container.resolve(ErrorPublisher.self)!)
                .environmentObject(AppDelegate.container.resolve(AppSync.self)!)
                .environmentObject(appSetting)
                .environment(\.managedObjectContext, CoreData.shared.viewContext)
        }
    }
}
