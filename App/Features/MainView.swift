import Combine
import SwiftUI

struct MainView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var appState: AppState

    var body: some View {
        if appState.registred {
            mainView
        } else {
            RegistrationView()
        }
    }

    #if os(iOS)
        var mainView: some View {
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
                                    appState.logout()
                                }, label: {
                                    Label("Logout", systemImage: "person")
                                }).foregroundColor(.red)
                            }, label: {
                                Label("Menu", systemImage: "line.3.horizontal.decrease.circle")
                            })
                        }
                    }
                    .appRouting()
            }
        }
    #endif

    #if os(macOS)
        var mainView: some View {
            NavigationSplitView {
                EntriesView()
                    .appRouting()
            } detail: {
                Text("Choose one entry")
            }.toolbar {
                ToolbarItem {
                    RefreshButton()
                }
            }
        }
    #endif
}

#if DEBUG
    struct MainView_Previews: PreviewProvider {
        static var previews: some View {
            Text("nothing")
        }
    }
#endif
