import Combine
import Foundation

class AppState: NSObject, ObservableObject {
    static var shared = AppState()

    @Published var registred: Bool = false {
        didSet {
            logger.info("App state registred \(self.registred)")
            WallabagUserDefaults.registred = registred
        }
    }

    @Published var showPlayer: Bool = false

    @Injector var session: WallabagSession
    @Injector var router: Router

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
