//
//  SceneDelegate.swift
//  wallabag
//
//  Created by Marinel Maxime on 11/07/2019.
//

import SwiftUI
import UIKit
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            
            let appState = AppState()
            
            
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: MainView().environmentObject(appState))
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_: UIScene) {   
    }

    func sceneDidBecomeActive(_: UIScene) {
        
    }

    func sceneWillResignActive(_: UIScene) {
    }

    func sceneWillEnterForeground(_: UIScene) {
    }

    func sceneDidEnterBackground(_: UIScene) {
    }
}
