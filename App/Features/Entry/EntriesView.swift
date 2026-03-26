import Combine
import CoreData
import RevenueCatUI
import SwiftUI

struct EntriesView: View {
    @Environment(Router.self) var router: Router
    @Environment(WallabagPlusStore.self) private var wallabagPlusStore
    @EnvironmentObject var appState: AppState
    @StateObject var searchViewModel = SearchViewModel()
    @AppStorage("entriesSortedById") var entriesSortedById = true
    @AppStorage("entriesSortedByReadingTime") var entriesSortedByReadingTime = false
    @AppStorage("entriesSortedByAscending") var entriesSortedByAscending = false
    @State private var showPaywallWallabagPlus = false

    var body: some View {
        EntriesListView(
            predicate: searchViewModel.predicate,
            entriesSortedById: entriesSortedById,
            entriesSortedByReadingTime: entriesSortedByReadingTime,
            entriesSortedByAscending: entriesSortedByAscending
        )
        .scrollContentBackground(.hidden)
        .safeAreaInset(edge: .top) {
            VStack(spacing: 0) {
                #if os(iOS)
                    PasteBoardView()
                #endif
                SearchView(searchViewModel: searchViewModel)
                    .padding(.bottom, 8)
                Divider()
            }
            .background(.ultraThinMaterial)
        }
        .onChange(of: entriesSortedById) { _, newValue in
            if newValue {
                entriesSortedByReadingTime = false
            }
        }
        .onChange(of: entriesSortedByReadingTime) { _, newValue in
            if newValue {
                entriesSortedById = false
            }
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
                    if !wallabagPlusStore.proUnlocked {
                        Button(action: {
                            showPaywallWallabagPlus = true
                        }, label: {
                            Label("wallabag Plus", systemImage: "hands.and.sparkles")
                        })
                        Divider()
                    }
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
        .sheet(isPresented: $showPaywallWallabagPlus) {
            PaywallView(displayCloseButton: true)
        }
        .navigationTitle("Entries")
         .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(.all, edges: .bottom)
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
