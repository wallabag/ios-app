//
//  DeleteEntryContextMenu.swift
//  wallabag
//
//  Created by Marinel Maxime on 16/10/2019.
//

import SwiftUI

struct DeleteEntryContextMenu: View {
    var entryPublisher: EntryPublisher
    var entry: Entry
    var body: some View {
        Button(action: {}, label: {
            Text("Delete")
            Image(systemName: "trash")
        })
    }
}

/* struct DeleteEntryContextMenu_Previews: PreviewProvider {
 static var previews: some View {
     DeleteEntryContextMenu()
 }
 } */
