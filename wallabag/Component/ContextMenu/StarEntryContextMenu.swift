//
//  FavoriteEntryContextMenu.swift
//  wallabag
//
//  Created by Marinel Maxime on 16/10/2019.
//

import SwiftUI

struct StarEntryContextMenu: View {
    @EnvironmentObject var appState: AppState
    var entryPublisher: EntryPublisher
    var entry: Entry
    var body: some View {
        Button(action: {
            self.appState.session.update(self.entry, parameters: ["favorite": (!self.entry.isStarred).int])
            self.entryPublisher.toggleStar(self.entry)
        }, label: {
            Text(entry.isStarred ? "Unstart" : "Mark as favorite")
            EntryPictoImage(entry: entry, keyPath: \.isStarred, picto: "star")
        })
    }
}
