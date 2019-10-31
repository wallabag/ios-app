//
//  ArticleListView.swift
//  wallabag
//
//  Created by Marinel Maxime on 27/10/2019.
//

import Foundation
import SwiftUI

struct EntriesListView: View {
    @EnvironmentObject var entryPublisher: EntryPublisher
    var body: some View {
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
}
