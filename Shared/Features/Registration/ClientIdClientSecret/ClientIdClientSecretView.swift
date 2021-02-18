import SwiftUI

struct ClientIdClientSecretView: View {
    @ObservedObject var clientIdSecretViewModel = ClientIdSecretViewModel()

    var body: some View {
        Form {
            Section(header: Text("Client id")) {
                TextField("Client id", text: $clientIdSecretViewModel.clientId)
                    .disableAutocorrection(true)
                #warning("fix me")
                // .autocapitalization(.none)
            }
            Section(header: Text("Client secret")) {
                TextField("Client secret", text: $clientIdSecretViewModel.clientSecret)
                    .disableAutocorrection(true)
                #warning("fix me")
                // .autocapitalization(.none)
            }
            NavigationLink("Next", destination: LoginView()).disabled(!clientIdSecretViewModel.isValid)
        }
        #warning("fix me")
        // .navigationBarTitle("Client id & secret")
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
