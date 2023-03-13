import SharedLib
import SwiftUI

struct ClientIdClientSecretView: View {
    @StateObject var clientIdSecretViewModel = ClientIdSecretViewModel()

    var body: some View {
        Form {
            Section(header: Text("Client id")) {
                TextField("Client id", text: $clientIdSecretViewModel.clientId)
                    .disableAutocorrection(true)
                #if os(iOS)
                    .autocapitalization(.none)
                #endif
            }
            Section(header: Text("Client secret")) {
                TextField("Client secret", text: $clientIdSecretViewModel.clientSecret)
                    .disableAutocorrection(true)
                #if os(iOS)
                    .autocapitalization(.none)
                #endif
            }
            NavigationLink("Next", destination: LoginView()).disabled(!clientIdSecretViewModel.isValid)
        }
        #if os(iOS)
        .navigationBarTitle("Client id & secret")
        .navigationBarItems(trailing:
            Link(destination: Bundle.infoForKey("DOCUMENTATION_URL")!.url!) {
                Text("Open documentation")
            })
        #endif
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
