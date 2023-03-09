import Combine
import SwiftUI

struct Main2View: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var appState: AppState

    var body: some View {
        if appState.registred {
            NavigationStack(path: $router.path) {
                EntriesView()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            RefreshButton()
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            SwiftUI.Menu(content: {
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
        } else {
            RegistrationView()
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
