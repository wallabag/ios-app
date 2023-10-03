import Combine
import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var router: Router

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
