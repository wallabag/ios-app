//
//  LoginTextFieldValidator.swift
//  wallabag
//
//  Created by Marinel Maxime on 10/10/2019.
//

import Combine
import Foundation

class LoginTextFieldValidator: ObservableObject {
    @Published var login: String = ""
    @Published var password: String = ""
    @Published var error: String?

    @Injector var appState: AppState

    private(set) var isValid: Bool = false
    private var cancellable: AnyCancellable?
    private var sessionCancellable: AnyCancellable?

    init() {
        login = WallabagUserDefaults.login
        cancellable = Publishers.CombineLatest($login, $password).sink { login, password in
            Log(password)
            Log(login)
            self.isValid = !login.isEmpty && !password.isEmpty
        }
        sessionCancellable = appState.session.$state.sink { state in
            if state == .error {
                self.error = "Connection error, please check your parameters"
            }
            if state == .connected {
                self.appState.registred = true
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
