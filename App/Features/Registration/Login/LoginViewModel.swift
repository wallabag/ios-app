import Combine
import Factory
import Foundation
import Observation
import SharedLib

@Observable
final class LoginViewModel {
    @ObservationIgnored
    @Injected(\.appState) private var appState
    @ObservationIgnored
    @Injected(\.wallabagSession) private var session
    @ObservationIgnored
    @Injected(\.router) private var router
    private var cancellable = Set<AnyCancellable>()

    var login: String = ""
    var password: String = ""
    var error: String?
    var isValid: Bool {
        !login.isEmpty && !password.isEmpty
    }

    init() {
        login = WallabagUserDefaults.login

        session.$state.receive(on: DispatchQueue.main).sink { [unowned self] state in
            switch state {
            case let .error(reason):
                error = reason
            case .connected:
                appState.registred = true
            case .unknown, .connecting, .offline:
                break
            }
        }.store(in: &cancellable)
    }

    func tryLogin() async {
        error = nil
        WallabagUserDefaults.login = login
        WallabagUserDefaults.password = password
        session.kit.host = WallabagUserDefaults.host
        await session.requestSession(
            clientId: WallabagUserDefaults.clientId,
            clientSecret: WallabagUserDefaults.clientSecret,
            username: login,
            password: password
        )
    }
}
