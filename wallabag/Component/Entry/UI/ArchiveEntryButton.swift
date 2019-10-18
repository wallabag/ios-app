//
//  ArchiveEntryContextMenu.swift
//  wallabag
//
//  Created by Marinel Maxime on 16/10/2019.
//

import SwiftUI

struct ArchiveEntryButton: View {
    @EnvironmentObject var appState: AppState
    var entryPublisher: EntryPublisher
    var entry: Entry
    var showText: Bool = true
    var body: some View {
        Button(action: {
            self.appState.session.update(self.entry, parameters: ["archive": (!self.entry.isArchived).int])
            self.entryPublisher.toggleArchive(self.entry)
        }, label: {
            if showText {
                Text(entry.isArchived ? "Mark as unread" : "Mark as read")
            }
            EntryPictoImage(entry: entry, keyPath: \.isArchived, picto: "book")
        })
    }
}
