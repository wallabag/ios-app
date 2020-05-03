//
//  LoginTextFieldValidator.swift
//  wallabag
//
//  Created by Marinel Maxime on 10/10/2019.
//

import Combine
import Foundation

class RegistrationLoginViewHandler: ObservableObject {
    @Published var login: String = ""
    @Published var password: String = ""
    @Published var error: String?

    @Injector var appState: AppState
    @Injector var router: Router

    private(set) var isValid: Bool = false
    private var cancellable = Set<AnyCancellable>()

    init() {
        login = WallabagUserDefaults.login
        Publishers.CombineLatest($login, $password).sink { [unowned self] login, password in
            self.isValid = !login.isEmpty && !password.isEmpty
        }.store(in: &cancellable)

        appState.session.$state.receive(on: DispatchQueue.main).sink { [unowned self] state in
            switch state {
            case let .error(reason):
                self.error = reason
            case .connected:
                self.appState.registred = true
                self.router.load(.entries)
            case .unknown:
                break
            case .connecting:
                break
            case .offline:
                break
            }
        }.store(in: &cancellable)
    }

    func tryLogin() {
        error = nil
        WallabagUserDefaults.login = login
        WallabagUserDefaults.password = password
        appState.session.kit.username = login
        appState.session.kit.password = password
        appState.session.requestSession()
    }

    deinit {
        cancellable.forEach { $0.cancel() }
    }
}
