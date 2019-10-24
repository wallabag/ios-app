//
//  ArticleListView.swift
//  wallabag
//
//  Created by Marinel Maxime on 11/07/2019.
//

import SwiftUI

struct ArticleListView: View {
    @EnvironmentObject var appSync: AppSync
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var entryPublisher: EntryPublisher

    var body: some View {
        NavigationView {
            VStack {
                RetrieveModePicker(filter: $entryPublisher.retrieveMode)
                ArticleTableView(entries: $entryPublisher.entries)
                    .navigationBarTitle("Articles")
                    .navigationBarItems(trailing:
                        ViewBuilder.buildBlock(
                            HStack {
                                RefreshButton()
                                NavigationLink(destination: AddEntryView(), label: { Image(systemName: "plus") })
                            }
                    ))
            }
        }
    }
}

#if DEBUG
    struct ArticleListView_Previews: PreviewProvider {
        static var previews: some View {
            ArticleListView()
        }
    }
#endif
