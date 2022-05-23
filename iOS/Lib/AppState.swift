import Combine
import Foundation
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

    private(set) var wallabagConfig: WallabagConfig?

    override init() {
        super.init()
        registred = WallabagUserDefaults.registred
    }

    func initSession() {
        if registred {
            logger.info("App state request session")
            session.requestSession(clientId: WallabagUserDefaults.clientId, clientSecret: WallabagUserDefaults.clientSecret, username: WallabagUserDefaults.login, password: WallabagUserDefaults.password)

            session.config { [weak self] config in
                self?.wallabagConfig = config
            }
        }
    }

    func logout() {
        logger.debug("Logout called")
        registred = false
        session.state = .unknown
        router.load(.registration)
    }
}
