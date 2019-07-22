//
//  LoginView.swift
//  wallabag
//
//  Created by Marinel Maxime on 19/07/2019.
//

import SwiftUI
import Combine


class LoginValidator: BindableObject {
    let didChange = PassthroughSubject<Void, Never>()
    var isValid: Bool = false {
        didSet {
            didChange.send()
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
    
    private func validate() {
        isValid = !login.isEmpty && !password.isEmpty
    }
}

struct LoginView: View {
    @ObjectBinding var loginValidator = LoginValidator()
    
    var body: some View {
        Form {
            Section(header: Text("Login")) {
                TextField($loginValidator.login)
            }
            Section(header: Text("Passwod")) {
                SecureField($loginValidator.password)
            }
            Button("Login") {
                
            }.disabled(!loginValidator.isValid)
        }
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
#endif
