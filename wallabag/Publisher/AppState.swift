//
//  AppState.swift
//  wallabag
//
//  Created by Marinel Maxime on 09/10/2019.
//

import Combine
import Foundation

#warning("Need to clean router")
class AppState: ObservableObject {
    @Published var registred: Bool = false {
        didSet {
            WallabagUserDefaults.registred = registred
        }
    }

    @Published var showMenu: Bool = false
    @Published var showPlayer: Bool = false

    @Injector var session: WallabagSession
    @Injector var router: Router

    init() {
        registred = WallabagUserDefaults.registred
    }

    func initSession() {
        if registred {
            session.requestSession()
        }
    }

    func logout() {
        registred = false
        router.route = .registration
    }
}
