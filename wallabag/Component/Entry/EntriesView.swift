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
    @State private var filter: RetrieveMode = RetrieveMode(fromCase: WallabagUserDefaults.defaultMode)

    @FetchRequest(entity: Entry.entity(), sortDescriptors: []) var entries: FetchedResults<Entry>

    var body: some View {
        NavigationView {
            VStack {
                // MARK: Pasteboard

                if pasteBoardPublisher.showPasteBoardView {
                    PasteBoardView().environmentObject(pasteBoardPublisher)
                }

                // MARK: Picker

                RetrieveModePicker(filter: self.$filter)
                EntriesListView(predicate: filter.predicate())
            }
            .navigationBarTitle(Text("Entry"))
            .navigationBarHidden(true)

            // MARK: SplitView

            entries.first.map { EntryView(entry: $0) }
        }
    }
}

#if DEBUG
    struct ArticleListView_Previews: PreviewProvider {
        static var previews: some View {
            EntriesView()
                .environmentObject(PasteBoardPublisher())
                .environmentObject(AppSync())
        }
    }
#endif
