import Combine
import Factory
import Foundation
import SwiftUI
import WallabagKit

final class AppState: NSObject, ObservableObject {
    @Injected(\.wallabagSession) private var session

    @Published var registred: Bool = false {
        didSet {
            WallabagUserDefaults.registred = registred
        }
    }

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
    }

    /// Fetch user config from server
    /// *Require server running version 2.5*
    private func fetchConfig() {
        logger.info("Fetch user config")
        session.config { [weak self] config in
            guard let config else { return }
            logger.debug("User config available")
            DispatchQueue.main.async {
                self?.readingSpeed = config.readingSpeed
            }
        }
    }
}
