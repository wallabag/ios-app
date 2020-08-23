//
//  ArchiveEntryContextMenu.swift
//  wallabag
//
//  Created by Marinel Maxime on 16/10/2019.
//

import SwiftUI

struct ArchiveEntryButton: View {
    @ObservedObject var entry: Entry
    var showText: Bool = true
    var body: some View {
        Button(action: {
            self.entry.toggleArchive()
        }, label: {
            if showText {
                Text(entry.isArchived ? "Mark as unread" : "Mark as read")
            }
            EntryPictoImage(entry: entry, keyPath: \.isArchived, picto: "book")
        })
    }
}
