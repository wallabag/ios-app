//
//  SceneDelegate.swift
//  wallabag
//
//  Created by Marinel Maxime on 11/07/2019.
//

import Combine
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    @Injector var appState: AppState

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView:
                MainView()
                    .environmentObject(appState)
                    .environment(\.managedObjectContext, CoreData.shared.viewContext))
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_: UIScene) {}

    func sceneDidBecomeActive(_: UIScene) {}

    func sceneWillResignActive(_: UIScene) {}

    func sceneWillEnterForeground(_: UIScene) {
        updateBadge()
    }

    func sceneDidEnterBackground(_: UIScene) {
        updateBadge()
    }
    
    private func updateBadge() {
        Log("\(WallabagUserDefaults.badgeEnabled)")
        if !WallabagUserDefaults.badgeEnabled {
            UIApplication.shared.applicationIconBadgeNumber = 0
            return
        }
        
        do {
            print("run fetch")
            let fetchRequest = Entry.fetchRequestSorted()
            fetchRequest.predicate = RetrieveMode(fromCase: WallabagUserDefaults.defaultMode).predicate()
            let entries = try CoreData.shared.viewContext.fetch(fetchRequest)
            UIApplication.shared.applicationIconBadgeNumber = entries.count
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
