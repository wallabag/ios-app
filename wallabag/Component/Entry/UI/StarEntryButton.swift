//
//  FavoriteEntryContextMenu.swift
//  wallabag
//
//  Created by Marinel Maxime on 16/10/2019.
//

import SwiftUI

struct StarEntryButton: View {
    @ObservedObject var entry: Entry
    var showText: Bool = true
    var body: some View {
        Button(action: {
            // @todo : move push server in obsersable
            //self.appState.session.update(self.entry, parameters: ["starred": (!self.entry.isStarred).int])
            self.entry.toggleStarred()
        }, label: {
            if showText {
                Text(entry.isStarred ? "Unstar" : "Mark as favorite")
            }
            EntryPictoImage(entry: entry, keyPath: \.isStarred, picto: "star")
        })
    }
}
