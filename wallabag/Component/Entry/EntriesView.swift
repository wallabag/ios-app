//
//  ArticleListView.swift
//  wallabag
//
//  Created by Marinel Maxime on 11/07/2019.
//

import CoreData
import SwiftUI

struct EntriesView: View {
    @ObservedObject var pasteBoardPublisher = PasteBoardPublisher()
    @EnvironmentObject var appSync: AppSync
    @EnvironmentObject var entryPublisher: EntryPublisher
    @State private var showAddView: Bool = false

    var body: some View {
        NavigationView {
            Group {
                if pasteBoardPublisher.showPasteBoardView {
                    PasteBoardView().environmentObject(pasteBoardPublisher)
                }
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
            .navigationBarItems(
                leading: Button(action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                }, label: { Image(systemName: "gear") }),
                trailing:
                HStack {
                    RefreshButton()
                    Button(action: { self.showAddView = true }, label: { Image(systemName: "plus").frame(width: 34, height: 34, alignment: .center) })
                }
            )

            entryPublisher.entries.first.map { EntryView(entry: $0) }
        }
    }
}

#if DEBUG
    struct ArticleListView_Previews: PreviewProvider {
        static var previews: some View {
            EntriesView()
                .environmentObject(PasteBoardPublisher())
                .environmentObject(AppSync())
                .environmentObject(EntryPublisher())
        }
    }
#endif
