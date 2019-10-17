//
//  ArchiveEntryContextMenu.swift
//  wallabag
//
//  Created by Marinel Maxime on 16/10/2019.
//

import SwiftUI

struct ArchiveEntryContextMenu: View {
    @EnvironmentObject var appState: AppState
    var entryPublisher: EntryPublisher
    var entry: Entry
    var body: some View {
        Button(action: {
            self.appState.session.update(self.entry, parameters: ["archive": (!self.entry.isArchived).int])
            self.entryPublisher.toggleArchive(self.entry)
        }, label: {
            Text(entry.isArchived ? "Mark as unread" : "Mark as read")
            EntryPictoImage(entry: entry, keyPath: \.isArchived, picto: "book")
        })
    }
}
