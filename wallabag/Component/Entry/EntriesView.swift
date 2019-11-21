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
    @EnvironmentObject var entryPublisher: EntryPublisher
    @State private var showAddView: Bool = false

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
                // WORKAROUND 13.2 navigation back crash
                NavigationLink(destination: AddEntryView(), isActive: $showAddView, label: { Image(systemName: "plus") }).hidden()
            }
            .navigationBarTitle("Articles")
            .navigationBarItems(trailing:
                HStack {
                    RefreshButton()
                    Button(action: { self.showAddView = true }, label: { Image(systemName: "plus") })
            })

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
