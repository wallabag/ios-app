import CoreData
import Foundation
import SwiftUI

struct EntriesListView: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @Environment(AppSync.self) var appSync: AppSync
    @FetchRequest var entries: FetchedResults<Entry>

    init(
        predicate: NSPredicate,
        entriesSortedById: Bool,
        entriesSortedByReadingTime: Bool,
        entriesSortedByAscending: Bool
    ) {
        var sortDescriptors: [NSSortDescriptor] = []
        if entriesSortedById {
            sortDescriptors.append(NSSortDescriptor(key: "id", ascending: entriesSortedByAscending))
        }

        if entriesSortedByReadingTime {
            sortDescriptors.append(NSSortDescriptor(key: "readingTime", ascending: entriesSortedByAscending))
        }

        _entries = FetchRequest(
            entity: Entry.entity(),
            sortDescriptors: sortDescriptors,
            predicate: predicate, animation: nil
        )
    }

    var body: some View {
        List {
            ForEach(entries) { entry in
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
                    Button(action: {
                        context.delete(entry)
                    }, label: {
                        Label("Delete", systemImage: "trash")
                    })
                    .tint(.red)
                    .labelStyle(.iconOnly)
                })
            }
        }
        .refreshable { appSync.requestSync() }
        .listStyle(.inset)
    }
}
