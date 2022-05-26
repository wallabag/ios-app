import Combine
import Foundation
import SwiftUI
import WallabagKit

class AppState: NSObject, ObservableObject {
    static var shared = AppState()

    @Published var registred: Bool = false {
        didSet {
            WallabagUserDefaults.registred = registred
        }
    }

    @Injector var session: WallabagSession
    @Injector var router: Router

    @AppStorage("readingSpeed") var readingSpeed: Double = 200

    override init() {
        super.init()
        registred = WallabagUserDefaults.registred
    }

    func initSession() {
        if registred {
            logger.info("App state request session")
            session.requestSession(clientId: WallabagUserDefaults.clientId, clientSecret: WallabagUserDefaults.clientSecret, username: WallabagUserDefaults.login, password: WallabagUserDefaults.password)

            fetchConfig()
        }
    }

    func logout() {
        logger.debug("Logout called")
        registred = false
        session.state = .unknown
        router.load(.registration)
    }

    /// Fetch user config from server
    /// *Require server running version 2.5*
    private func fetchConfig() {
        logger.info("Fetch user config")
        session.config { [weak self] config in
            guard let config = config else { return }
            logger.debug("User config available")
            DispatchQueue.main.async {
                self?.readingSpeed = config.readingSpeed
            }
        }
    }
}
