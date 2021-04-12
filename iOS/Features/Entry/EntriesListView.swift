import CoreData
import Foundation
import SwiftUI

struct EntriesListView: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @FetchRequest var entries: FetchedResults<Entry>
    @EnvironmentObject var router: Router

    init(predicate: NSPredicate) {
        _entries = FetchRequest(entity: Entry.entity(), sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)], predicate: predicate, animation: nil)
    }

    var body: some View {
        List(entries, id: \.id) { entry in
            Button(action: {
                self.router.load(.entry(entry))
            }, label: {
                EntryRowView(entry: entry)
                    .contentShape(Rectangle())
                    .contextMenu {
                        ArchiveEntryButton(entry: entry)
                        StarEntryButton(entry: entry)
                    }
            }).buttonStyle(PlainButtonStyle())
        }
    }
}
