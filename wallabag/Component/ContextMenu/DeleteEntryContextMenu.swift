//
//  DeleteEntryContextMenu.swift
//  wallabag
//
//  Created by Marinel Maxime on 16/10/2019.
//

import SwiftUI

struct DeleteEntryContextMenu: View {
    @EnvironmentObject var appState: AppState
    var entry: Entry
    var body: some View {
        Button(action: {
            self.appState.session.delete(entry: self.entry)
        }, label: {
            Text("Delete")
            Image(systemName: "trash")
        })
    }
}
