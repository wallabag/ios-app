//
//  LoginView.swift
//  wallabag
//
//  Created by Marinel Maxime on 19/07/2019.
//

import Combine
import SwiftUI

class LoginHandler: ObservableObject {
    @Published var isValid: Bool = false {
        didSet {
            if isValid {
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

    private func validate() {
        isValid = !login.isEmpty && !password.isEmpty
    }
}

struct LoginView: View {
    @ObservedObject var loginHandler = LoginHandler()
    @EnvironmentObject var appState: AppState

    var body: some View {
        Form {
            Section(header: Text("Login")) {
                TextField("Login", text: $loginHandler.login).onAppear {
                    self.loginHandler.login = WallabagUserDefaults.login
                }
            }
            Section(header: Text("Passwod")) {
                SecureField("Password", text: $loginHandler.password)
            }
            Button("Login") {
                self.appState.registred = true
            }.disabled(!loginHandler.isValid)
        }.navigationBarTitle("Login & Password")
    }
}

#if DEBUG
    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView()
        }
    }
#endif
