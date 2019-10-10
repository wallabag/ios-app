//
//  LoginTextFieldValidator.swift
//  wallabag
//
//  Created by Marinel Maxime on 10/10/2019.
//

import Combine
import Foundation

class LoginTextFieldValidator: ObservableObject {
    @Published var isValid: Bool = false {
        didSet {
            if isValid {
                WallabagUserDefaults.login = login
                WallabagUserDefaults.password = password
            }
        }
    }

    var login: String = "" {
        didSet {
            validate()
        }
    }

    var password: String = "" {
        didSet {
            validate()
        }
    }

    init() {
        login = WallabagUserDefaults.login
    }

    private func validate() {
        isValid = !login.isEmpty && !password.isEmpty
    }
}
