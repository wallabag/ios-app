//
//  LoginTextFieldValidator.swift
//  wallabag
//
//  Created by Marinel Maxime on 10/10/2019.
//

import Combine
import Foundation
import Combine

class LoginTextFieldValidator: ObservableObject {
    private(set) var isValid: Bool = false {
        didSet {
            if isValid {
                WallabagUserDefaults.login = login
                WallabagUserDefaults.password = password
            }
        }
    }

    @Published var login: String = ""
    @Published var password: String = ""

    private var cancellable: AnyCancellable?
    
    init() {
        login = WallabagUserDefaults.login
        
        cancellable = Publishers.CombineLatest($login, $password).sink { login, password in
            self.isValid = !login.isEmpty && !password.isEmpty
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
}
