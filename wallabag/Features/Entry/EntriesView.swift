import Combine
import CoreData
import SwiftUI

struct EntriesView: View {
    @ObservedObject var pasteBoardViewModel = PasteBoardViewModel()
    @ObservedObject var searchViewModel = SearchViewModel()

    var body: some View {
        VStack {
            // MARK: Pasteboard

            if pasteBoardViewModel.showPasteBoardView {
                PasteBoardView().environmentObject(pasteBoardViewModel)
            }

            // MARK: Picker

            SearchView(searchViewModel: searchViewModel)
            EntriesListView(predicate: searchViewModel.predicate)
        }
        .navigationBarTitle(Text("Entry"))
        .navigationBarHidden(true)
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
