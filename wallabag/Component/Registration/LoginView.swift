//
//  LoginView.swift
//  wallabag
//
//  Created by Marinel Maxime on 19/07/2019.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var loginHandler = LoginTextFieldValidator()
    @EnvironmentObject var appState: AppState

    var body: some View {
        Form {
            Section(header: Text("Login")) {
                TextField("Login", text: $loginHandler.login)
            }
            Section(header: Text("Password")) {
                SecureField("Password", text: $loginHandler.password)
            }
            Button("Login") {
                self.loginHandler.tryLogin()
            }.disabled(!loginHandler.isValid)
            loginHandler.error.map {
                Text($0).foregroundColor(.red)
            }
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
