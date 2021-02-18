import SwiftUI

struct ServerView: View {
    @ObservedObject var serverViewModel = ServerViewModel()

    var body: some View {
        Form {
            Section(header: Text("Server")) {
                TextField("https://your-instance.domain", text: $serverViewModel.url)
                    .disableAutocorrection(true)
                #warning("fix me")
                // .autocapitalization(.none)
            }
            NavigationLink(destination: ClientIdClientSecretView()) {
                Text("Next")
            } // .disabled(!serverViewModel.isValid)
        }
        #warning("fix me")
        // .navigationBarTitle("Server")
    }
}

#if DEBUG
    struct ServerView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                ServerView()
            }
        }
    }
#endif
