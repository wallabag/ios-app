import Combine
import Factory
import Foundation
import SharedLib

class LoginViewModel: ObservableObject {
    @Injected(\.appState) private var appState
    @Injected(\.wallabagSession) private var session
    @Injected(\.router) private var router

    @Published var login: String = ""
    @Published var password: String = ""
    @Published var error: String?

    private(set) var isValid: Bool = false
    private var cancellable = Set<AnyCancellable>()

    init() {
        login = WallabagUserDefaults.login
        Publishers.CombineLatest($login, $password).sink { [unowned self] login, password in
            isValid = !login.isEmpty && !password.isEmpty
        }.store(in: &cancellable)

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

    func tryLogin() {
        error = nil
        WallabagUserDefaults.login = login
        WallabagUserDefaults.password = password
        session.kit.host = WallabagUserDefaults.host
        session.requestSession(
            clientId: WallabagUserDefaults.clientId,
            clientSecret: WallabagUserDefaults.clientSecret,
            username: login,
            password: password
        )
    }

    deinit {
        cancellable.forEach { $0.cancel() }
    }
}
