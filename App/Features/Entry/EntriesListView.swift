import CoreData
import Foundation
import SwiftUI

struct EntriesListView: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @EnvironmentObject var appSync: AppSync
    @FetchRequest var entries: FetchedResults<Entry>
    @EnvironmentObject var router: Router

    init(predicate: NSPredicate) {
        _entries = FetchRequest(entity: Entry.entity(), sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)], predicate: predicate, animation: nil)
    }

    var body: some View {
        List {
            ForEach(entries, id: \.id) { entry in
                NavigationLink(value: RoutePath.entry(entry)) {
                    EntryRowView(entry: entry)
                        .contentShape(Rectangle())
                        .contextMenu {
                            ArchiveEntryButton(entry: entry)
                            StarEntryButton(entry: entry)
                        }
                }
                .buttonStyle(.plain)
                .swipeActions(allowsFullSwipe: false, content: {
                    ArchiveEntryButton(entry: entry)
                        .tint(.blue)
                        .labelStyle(.iconOnly)
                    StarEntryButton(entry: entry)
                        .tint(.orange)
                        .labelStyle(.iconOnly)
                })
            }
        }
        .refreshable { appSync.requestSync() }
        .listStyle(.inset)
    }
}
