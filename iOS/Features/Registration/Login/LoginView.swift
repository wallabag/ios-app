import SwiftUI

struct LoginView: View {
    @StateObject var loginViewModel = LoginViewModel()

    var body: some View {
        Form {
            Section(header: Text("Login")) {
                TextField("Login", text: $loginViewModel.login)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }
            Section(header: Text("Password")) {
                SecureField("Password", text: $loginViewModel.password)
            }
            Button("Login") {
                self.loginViewModel.tryLogin()
            }.disabled(!loginViewModel.isValid)
            loginViewModel.error.map {
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
