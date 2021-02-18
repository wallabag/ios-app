import SwiftUI

struct SidebarView: View {
    @ObservedObject var store: EntriesStore
    @Binding var selectedMenu: String?
    @Binding var selectedEntry: EntryMac?

    var body: some View {
        List(selection: $selectedMenu) {
            Section {
                NavigationLink(destination: EntriesListView(entries: store.entries, selectedEntry: $selectedEntry)) {
                    Text("Entries")
                }
            }
            Section {
                NavigationLink(destination: Register()) {
                    Text("Register")
                }
            }
        }.listStyle(SidebarListStyle())
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(
            store: EntriesStore(), selectedMenu: .constant("test"), selectedEntry: .constant(.init(title: "test", content: "test"))
        )
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
