//
//  FavoriteEntryContextMenu.swift
//  wallabag
//
//  Created by Marinel Maxime on 16/10/2019.
//

import SwiftUI

struct StarEntryButton: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var entryPublisher: EntryPublisher
    @ObservedObject var entry: Entry
    var showText: Bool = true
    var body: some View {
        Button(action: {
            self.appState.session.update(self.entry, parameters: ["starred": (!self.entry.isStarred).int])
            self.entryPublisher.toggleStar(self.entry)
        }, label: {
            if showText {
                Text(entry.isStarred ? "Unstart" : "Mark as favorite")
            }
            EntryPictoImage(entry: entry, keyPath: \.isStarred, picto: "star")
        })
    }
}
