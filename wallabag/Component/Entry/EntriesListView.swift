//
//  EntriesListView.swift
//  wallabag
//
//  Created by Marinel Maxime on 24/12/2019.
//

import Foundation
import SwiftUI

struct EntriesListView: View {
    @FetchRequest var entries: FetchedResults<Entry>
    @EnvironmentObject var router: Router

    init(predicate: NSPredicate) {
        _entries = FetchRequest(entity: Entry.entity(), sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)], predicate: predicate, animation: nil)
    }

    var body: some View {
        List(entries, id: \.id) { entry in
            Button(action: {
                self.router.load(.entry(entry))
            }, label: {
                EntryRowView(entry: entry).contextMenu {
                    ArchiveEntryButton(entry: entry)
                    StarEntryButton(entry: entry)
                    DeleteEntryButton(entry: entry)
                }
            }).buttonStyle(PlainButtonStyle())
        }
    }
}
