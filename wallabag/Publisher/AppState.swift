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

    @Injector var session: WallabagSession
    @Injector var router: Router

    override init() {
        super.init()
        registred = WallabagUserDefaults.registred
    }

    func initSession() {
        if registred {
            session.requestSession()
        }
    }

    func logout() {
        registred = false
        session.state = .unknown
        WallabagUserDefaults.host = ""
        WallabagUserDefaults.accessToken = ""
        WallabagUserDefaults.clientId = ""
        WallabagUserDefaults.clientSecret = ""
        WallabagUserDefaults.password = ""
        WallabagUserDefaults.login = ""
        router.route = .registration
    }
}
