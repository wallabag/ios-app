import Combine
import CoreData
import SwiftUI

struct EntriesView: View {
    @StateObject var searchViewModel = SearchViewModel()

    var body: some View {
        VStack {
            #if os(iOS)
                PasteBoardView()
            #endif
            SearchView(searchViewModel: searchViewModel)
            EntriesListView(predicate: searchViewModel.predicate)
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
