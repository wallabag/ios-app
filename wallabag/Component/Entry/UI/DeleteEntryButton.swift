//
//  DeleteEntryContextMenu.swift
//  wallabag
//
//  Created by Marinel Maxime on 16/10/2019.
//

import CoreData
import SwiftUI

struct DeleteEntryButton: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    var entry: Entry
    var showText: Bool = true
    var body: some View {
        Button(action: {
            self.context.delete(self.entry)
        }, label: {
            if showText {
                Text("Delete")
            }
            Image(systemName: "trash")
        })
    }
}
