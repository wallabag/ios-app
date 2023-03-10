import Combine
import SwiftUI

struct MainView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var appState: AppState

    var body: some View {
        if appState.registred {
            #if os(iOS)
                ios
            #endif
            #if os(macOS)
                macOS
            #endif

        } else {
            RegistrationView()
        }
    }

    #if os(iOS)
        var ios: some View {
            NavigationStack(path: $router.path) {
                EntriesView()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            RefreshButton()
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            Menu(content: {
                                Button(action: {
                                    router.path.append(RoutePath.addEntry)
                                }, label: {
                                    Label("Add entry", systemImage: "tray.and.arrow.down")
                                })
                                Button(action: {
                                    router.path.append(RoutePath.about)
                                }, label: {
                                    Label("About", systemImage: "questionmark")
                                })
                                Button(action: {
                                    router.path.append(RoutePath.tips)
                                }, label: {
                                    Label("Don", systemImage: "heart")
                                })
                                Divider()
                                Button(action: {
                                    router.path.append(RoutePath.setting)
                                }, label: {
                                    Label("Setting", systemImage: "gear")
                                })
                                Divider()
                                Button(role: .destructive, action: {
                                    self.appState.logout()
                                }) {
                                    Label("Logout", systemImage: "person")
                                }.foregroundColor(.red)
                            }, label: {
                                Label("Menu", systemImage: "line.3.horizontal.decrease.circle")
                            })
                        }
                    }
                    .navigationDestination(for: RoutePath.self) { route in
                        switch route {
                        case .addEntry:
                            AddEntryView()
                        case let .entry(entry):
                            EntryView(entry: entry)
                        case .about:
                            AboutView()
                        case .tips:
                            TipView()
                        case .setting:
                            SettingView()
                        default:
                            Text("test")
                        }
                    }
            }
        }
    #endif

    var macOS: some View {
        NavigationSplitView {
            EntriesView()
                .navigationDestination(for: RoutePath.self) { route in
                    switch route {
                    case .addEntry:
                        AddEntryView()
                    case let .entry(entry):
                        EntryView(entry: entry)
                    case .about:
                        AboutView()
                    case .tips:
                        TipView()
                    case .setting:
                        SettingView()
                    default:
                        Text("test")
                    }
                }
        } detail: {
            Text("Detail View")
        }.toolbar {
            ToolbarItem {
                RefreshButton()
            }
        }
    }
}

#if DEBUG
    struct MainView_Previews: PreviewProvider {
        static var previews: some View {
            Text("nothing")
        }
    }
#endif
