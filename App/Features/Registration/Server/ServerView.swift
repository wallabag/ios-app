import SwiftUI

struct ServerView: View {
    @State private var serverViewModel = ServerViewModel()

    var body: some View {
        Form {
            Section(header: Text("Server")) {
                TextField("https://your-instance.domain", text: $serverViewModel.url)
                    .disableAutocorrection(true)
                #if os(iOS)
                    .autocapitalization(.none)
                #endif
            }
            Button(action: {
                serverViewModel.goNext()
            }, label: {
                Text("Next")
            })
            .disabled(!serverViewModel.isValid)
        }
        .navigationDestination(isPresented: $serverViewModel.shouldGoNextStep) {
            ClientIdClientSecretView()
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
