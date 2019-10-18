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
    @ObservedObject var entryPublisher = EntryPublisher()
    @State var showAdd: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                RetrieveModePicker(filter: $entryPublisher.retrieveMode)
                List(entryPublisher.entries, id: \.id) { entry in
                    NavigationLink(destination: ArticleView(entry: entry, entryPublisher: self.entryPublisher)) {
                        ArticleRowView(entry: entry).contextMenu {
                            ArchiveEntryButton(entryPublisher: self.entryPublisher, entry: entry)
                            StarEntryButton(entryPublisher: self.entryPublisher, entry: entry)
                            DeleteEntryButton(entryPublisher: self.entryPublisher, entry: entry)
                        }
                    }
                }.onAppear(perform: entryPublisher.loadEntries)
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
