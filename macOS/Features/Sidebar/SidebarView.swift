import SwiftUI

struct SidebarView: View {
    var body: some View {
        Section {
            List {
                ForEach(RetrieveMode.allCases, id: \.self) { retrieveMode in
                    NavigationLink(destination: EntriesListView(predicate: retrieveMode.predicate())) {
                        Label(LocalizedStringKey(retrieveMode.rawValue), systemImage: "tray")
                    }
                }
            }.listStyle(SidebarListStyle())
        }
        Divider()
        Section {
            List {
                Button(action: {
                    Router.shared.load(.registration)
                }) {
                    Label("Account", systemImage: "person")
                }
            }.listStyle(SidebarListStyle())
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}

struct Register: View {
    @State var server: String = ""
    var body: some View {
        Form {
            Section {
                TextField("Server", text: $server)
            }
        }
    }
}
