import os
import SwiftUI

let logger = Logger(subsystem: "fr.district-web.wallabag", category: "main")

@main
struct wallabagMacApp: App {
    @StateObject var appState = AppState.shared
    @StateObject var router = Router.shared
    @StateObject var entriesStore = EntriesStore()
    @State private var selectedMenu: String? = "Entries"
    @State private var selectedEntry: EntryMac?

    var body: some Scene {
        WindowGroup {
            if appState.registred {
                NavigationView {
                    SidebarView(store: entriesStore, selectedMenu: $selectedMenu, selectedEntry: $selectedEntry)
                    if let menu = selectedMenu {
                        EntriesListView(entries: entriesStore.entries, selectedEntry: $selectedEntry)
                    }
                    if let entry = selectedEntry {
                        EntryView(entry: entry)
                    }
                }
            } else {
                RegistrationView()
                    .frame(minWidth: 400, minHeight: 400)
            }
        }
    }
}

struct EntriesListView: View {
    let entries: [EntryMac]
    @Binding var selectedEntry: EntryMac?
    var body: some View {
        List {
            ForEach(entries) { entry in
                NavigationLink(destination: EntryView(entry: entry), tag: entry, selection: $selectedEntry) {
                    Text(entry.title)
                }
            }
        }
    }
}

class EntriesStore: ObservableObject {
    @Published var entries: [EntryMac] = [
        .init(
            title: "Facebook vole vos data",
            content: "aea"
        ),
        .init(
            title: "Google vole vos data",
            content: "aea"
        ),
    ]
}

struct EntryView: View {
    let entry: EntryMac
    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.title)
                .font(.headline)
            Text(entry.content)
        }
    }
}

struct EntryMac: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let content: String
}
