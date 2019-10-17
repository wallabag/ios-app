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
                    NavigationLink(destination: ArticleView(entry: entry)) {
                        ArticleRowView(entry: entry).contextMenu {
                            ArchiveEntryContextMenu(entryPublisher: self.entryPublisher, entry: entry)
                            StarEntryContextMenu(entryPublisher: self.entryPublisher, entry: entry)
                            DeleteEntryContextMenu(entry: entry)
                        }
                    }
                }.onAppear(perform: entryPublisher.loadEntries)
                    .navigationBarTitle("Articles")
                    .navigationBarItems(trailing:
                        ViewBuilder.buildBlock(
                            HStack {
                                Button(
                                    action: {
                                        self.appSync.requestSync()
                                    },
                                    label: {
                                        Image(systemName: "arrow.counterclockwise")
                                    }
                                ).disabled(appSync.inProgress)
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
