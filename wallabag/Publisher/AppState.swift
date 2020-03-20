//
//  AppState.swift
//  wallabag
//
//  Created by Marinel Maxime on 09/10/2019.
//

import Combine
import Foundation

#warning("Need to clean router")
class AppState: NSObject, ObservableObject {
    @Published var registred: Bool = false {
        didSet {
            WallabagUserDefaults.registred = registred
        }
    }

    @Published var showMenu: Bool = false
    @Published var showPlayer: Bool = false
    @Published var refreshing: Bool = false

    @Injector var session: WallabagSession
    @Injector var router: Router

    override init() {
        super.init()
        registred = WallabagUserDefaults.registred
        if registred {
            initSession()
        }
    }

    private func initSession() {
        session.requestSession()
    }

    func logout() {
        registred = false
        router.route = .registration
    }
}
