import Combine
import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var player: PlayerPublisher
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
            ZStack {
                GeometryReader { geometry in
                    NavigationStack(path: $router.path) {
                        EntriesView()
                            .appRouting()
                    }
                    if player.showPlayer {
                        PlayerView()
                            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topTrailing)
                            .transition(.move(edge: .trailing))
                            .offset(x: 0, y: 60)
                    }
                }
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
