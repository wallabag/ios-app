import Combine
import CoreData
import SwiftUI

struct EntriesView: View {
    @Environment(Router.self) var router: Router
    @EnvironmentObject var appState: AppState
    @StateObject var searchViewModel = SearchViewModel()
    @State var entriesSortedById = true
    @State var entriesSortedByReadingTime = false
    @State var entriesSortedByAscending = false

    var body: some View {
        VStack {
            #if os(iOS)
                PasteBoardView()
            #endif
            SearchView(searchViewModel: searchViewModel)
            EntriesListView(
                predicate: searchViewModel.predicate,
                entriesSortedById: entriesSortedById,
                entriesSortedByReadingTime: entriesSortedByReadingTime,
                entriesSortedByAscending: entriesSortedByAscending
            )
        }
        .onChange(of: entriesSortedByReadingTime) { _, _ in
            entriesSortedById = false
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Menu(content: {
                    Toggle("Order by id", systemImage: "line.3.horizontal.decrease.circle", isOn: $entriesSortedById)
                    Toggle("Order by reading time", systemImage: "clock.arrow.circlepath", isOn: $entriesSortedByReadingTime)
                    Divider()
                    Toggle("Sorting", systemImage: entriesSortedByAscending ? "arrow.up.circle" : "arrow.down.circle", isOn: $entriesSortedByAscending)
                }, label: {
                    Label("Sort options", systemImage: "line.3.horizontal.decrease.circle")
                })
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
                    NavigationLink(value: RoutePath.wallabagPlus) {
                        Label("wallabag Plus", systemImage: "hands.and.sparkles")
                    }
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
