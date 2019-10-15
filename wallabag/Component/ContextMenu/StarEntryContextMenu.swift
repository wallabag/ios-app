//
//  FavoriteEntryContextMenu.swift
//  wallabag
//
//  Created by Marinel Maxime on 16/10/2019.
//

import SwiftUI

struct StarEntryContextMenu: View {
    var entryPublisher: EntryPublisher
    var entry: Entry
    var body: some View {
        Button(action: {
            self.entryPublisher.toggleStar(self.entry)
        }, label: {
            Text(entry.isStarred ? "Unstart" : "Mark as favorite")
            Image(systemName: entry.isStarred ? "star.fill" : "star")
        })
    }
}

/* struct FavoriteEntryContextMenu_Previews: PreviewProvider {
 static var previews: some View {
     FavoriteEntryContextMenu()
 }
 } */
