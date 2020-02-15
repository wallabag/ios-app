//
//  LoginTextFieldValidator.swift
//  wallabag
//
//  Created by Marinel Maxime on 10/10/2019.
//

import Combine
import Foundation

#warning("Must be rewrite! So many thing!")
class LoginTextFieldValidator: ObservableObject {
    @Published var login: String = ""
    @Published var password: String = ""
    @Published var error: String?

    @Injector var appState: AppState
    @Injector var router: Router

    private(set) var isValid: Bool = false
    private var cancellable: AnyCancellable?
    private var sessionCancellable: AnyCancellable?

    init() {
        login = WallabagUserDefaults.login
        cancellable = Publishers.CombineLatest($login, $password).sink { login, password in
            self.isValid = !login.isEmpty && !password.isEmpty
        }

        sessionCancellable = appState.session.$state.sink { state in
            switch state {
            case let .error(reason):
                self.error = reason
            case .connected:
                DispatchQueue.main.async {
                    self.appState.registred = true
                    self.router.route = .entries
                }
            case .unknown:
                break
            case .connecting:
                break
            case .offline:
                break
            }
        }
    }

    func tryLogin() {
        WallabagUserDefaults.login = login
        WallabagUserDefaults.password = password
        appState.session.requestSession()
    }

    deinit {
        cancellable?.cancel()
        sessionCancellable?.cancel()
    }
}
