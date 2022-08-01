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
            loginViewModel.error.map { error in
                VStack {
                    Text(error).foregroundColor(.red)
                    Link("Report issue", destination: "https://github.com/wallabag/ios-app/issues")
                }
            }
        }.navigationBarTitle("Login & Password")
            .navigationBarItems(trailing:
                Link(destination: Bundle.infoForKey("DOCUMENTATION_URL")!.url!) {
                    Text("Open documentation")
                })
    }
}

#if DEBUG
    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView()
        }
    }
#endif
