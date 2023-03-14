import SwiftUI

struct ServerView: View {
    @StateObject var serverViewModel = ServerViewModel()

    var body: some View {
        Form {
            Section(header: Text("Server")) {
                TextField("https://your-instance.domain", text: $serverViewModel.url)
                    .disableAutocorrection(true)
                #if os(iOS)
                    .autocapitalization(.none)
                #endif
            }
            NavigationLink(destination: ClientIdClientSecretView()) {
                Text("Next")
            }.disabled(!serverViewModel.isValid)
        }
        #if os(iOS)
        .navigationBarTitle("Server")
        .navigationBarItems(trailing:
            Link(destination: Bundle.infoForKey("DOCUMENTATION_URL")!.url!) {
                Text("Open documentation")
            })
        #endif
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
