//
//  AppState.swift
//  wallabag
//
//  Created by Marinel Maxime on 09/10/2019.
//

import Combine
import Foundation
import Logging

#warning("Need to clean router")
class AppState: NSObject, ObservableObject {
    @Published var registred: Bool = false {
        didSet {
            logger.info("App state registred \(registred)")
            WallabagUserDefaults.registred = registred
        }
    }

    // @Published var showMenu: Bool = false
    @Published var showPlayer: Bool = false

    @Injector var session: WallabagSession
    @Injector var router: Router
    @Injector var logger: Logger

    override init() {
        super.init()
        registred = WallabagUserDefaults.registred
    }

    func initSession() {
        if registred {
            logger.info("App state request session")
            session.requestSession()
        }
    }

    func logout() {
        logger.debug("Logout called")
        registred = false
        session.state = .unknown
        router.load(.registration)
    }
}
