import Combine
import CoreData
import SwiftUI

struct EntriesView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var appState: AppState
    @StateObject var searchViewModel = SearchViewModel()
    @State var entriesSortAscending = false

    var body: some View {
        VStack {
            #if os(iOS)
                PasteBoardView()
            #endif
            SearchView(searchViewModel: searchViewModel)
            EntriesListView(predicate: searchViewModel.predicate, entriesSortAscending: entriesSortAscending)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: {
                        entriesSortAscending.toggle()
                    }, label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .rotationEffect(.degrees(entriesSortAscending ? 180 : 0))
                    })
                    RefreshButton()
                }
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
                    Label("Menu", systemImage: "list.bullet")
                })
            }
        }
        .navigationTitle("Entries")
    }
}

#if DEBUG
    struct ArticleListView_Previews: PreviewProvider {
        static var previews: some View {
            EntriesView()
            #if os(iOS)
                .environmentObject(PasteBoardViewModel())
            #endif
        }
    }
#endif
