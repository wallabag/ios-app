//
//  ArticleListView.swift
//  wallabag
//
//  Created by Marinel Maxime on 11/07/2019.
//

import CoreData
import SwiftUI

struct EntriesView: View {
    @EnvironmentObject var appSync: AppSync
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var entryPublisher: EntryPublisher

    var body: some View {
        NavigationView {
            Group {
                RetrieveModePicker(filter: $entryPublisher.retrieveMode)
                List(entryPublisher.entries) { entry in
                    NavigationLink(destination: EntryView(entry: entry)) {
                        EntryRowView(entry: entry).contextMenu {
                            ArchiveEntryButton(entry: entry)
                            StarEntryButton(entry: entry)
                            DeleteEntryButton(entry: entry)
                        }
                    }
                }
            }
            .navigationBarTitle("Articles")
            .navigationBarItems(trailing:
                ViewBuilder.buildBlock(
                    HStack {
                        RefreshButton()
                        NavigationLink(destination: AddEntryView(), label: { Image(systemName: "plus") })
                    }
            ))

            entryPublisher.entries.first.map { EntryView(entry: $0) }
        }
    }
}

#if DEBUG
    struct ArticleListView_Previews: PreviewProvider {
        static var previews: some View {
            EntriesView()
        }
    }
#endif
