import CoreData
import SwiftUI

struct DeleteEntryButton: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    var entry: Entry
    var showText: Bool = true
    var action: (() -> Void)?
    var body: some View {
        Button(action: {
            self.context.delete(self.entry)
            self.action?()
        }, label: {
            if showText {
                Text("Delete")
            }
            Image(systemName: "trash")
        })
    }
}
