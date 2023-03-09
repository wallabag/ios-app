import Combine
import CoreData
import SwiftUI

struct EntriesView: View {
    @StateObject var searchViewModel = SearchViewModel()

    var body: some View {
        VStack {
            PasteBoardView()
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
                .environmentObject(PasteBoardViewModel())
        }
    }
#endif
