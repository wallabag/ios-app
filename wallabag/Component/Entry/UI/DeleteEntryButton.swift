//
//  DeleteEntryContextMenu.swift
//  wallabag
//
//  Created by Marinel Maxime on 16/10/2019.
//

import SwiftUI
import CoreData

struct DeleteEntryButton: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    var entry: Entry
    var showText: Bool = true
    var body: some View {
        Button(action: {
            #warning("// TODO : move logic to obsersable")
            //self.appState.session.delete(entry: self.entry)
            self.context.delete(self.entry)
        }, label: {
            if showText {
                Text("Delete")
            }
            Image(systemName: "trash")
        })
    }
}
