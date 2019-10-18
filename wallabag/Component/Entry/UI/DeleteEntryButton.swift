//
//  DeleteEntryContextMenu.swift
//  wallabag
//
//  Created by Marinel Maxime on 16/10/2019.
//

import SwiftUI

struct DeleteEntryButton: View {
    @EnvironmentObject var appState: AppState
    var entryPublisher: EntryPublisher
    var entry: Entry
    var showText: Bool = true
    var body: some View {
        Button(action: {
            self.appState.session.delete(entry: self.entry)
            self.entryPublisher.delete(self.entry)
        }, label: {
            if showText {
                Text("Delete")
            }
            Image(systemName: "trash")
        })
    }
}
