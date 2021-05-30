import SwiftUI

struct ClientIdClientSecretView: View {
    @StateObject var clientIdSecretViewModel = ClientIdSecretViewModel()

    var body: some View {
        Form {
            Section(header: Text("Client id")) {
                TextField("Client id", text: $clientIdSecretViewModel.clientId)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }
            Section(header: Text("Client secret")) {
                TextField("Client secret", text: $clientIdSecretViewModel.clientSecret)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }
            NavigationLink("Next", destination: LoginView()).disabled(!clientIdSecretViewModel.isValid)
        }.navigationBarTitle("Client id & secret")
    }
}

#if DEBUG
    struct ClientIdClientSecretView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                ClientIdClientSecretView()
            }
        }
    }
#endif
