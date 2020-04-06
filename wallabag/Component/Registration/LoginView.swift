//
//  LoginView.swift
//  wallabag
//
//  Created by Marinel Maxime on 19/07/2019.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var loginViewHandler = RegistrationLoginViewHandler()

    var body: some View {
        Form {
            Section(header: Text("Login")) {
                TextField("Login", text: $loginViewHandler.login)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }
            Section(header: Text("Password")) {
                SecureField("Password", text: $loginViewHandler.password)
            }
            Button("Login") {
                self.loginViewHandler.tryLogin()
            }.disabled(!loginViewHandler.isValid)
            loginViewHandler.error.map {
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
