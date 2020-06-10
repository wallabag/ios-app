//
//  ArticleListView.swift
//  wallabag
//
//  Created by Marinel Maxime on 11/07/2019.
//

import Combine
import CoreData
import SwiftUI

struct EntriesView: View {
    @ObservedObject var pasteBoardPublisher = PasteBoardPublisher()
    @ObservedObject var searchPublisher = SearchPublisher()

    var body: some View {
        VStack {
            // MARK: Pasteboard

            if pasteBoardPublisher.showPasteBoardView {
                PasteBoardView().environmentObject(pasteBoardPublisher)
            }

            // MARK: Picker

            SearchView(searchPublisher: searchPublisher)
            EntriesListView(predicate: searchPublisher.predicate)
            // PlayerView()
        }
        .navigationBarTitle(Text("Entry"))
        .navigationBarHidden(true)
    }
}

#if DEBUG
    struct ArticleListView_Previews: PreviewProvider {
        static var previews: some View {
            EntriesView()
                .environmentObject(PasteBoardPublisher())
        }
    }
#endif
