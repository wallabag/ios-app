import SwiftUI

struct ArchiveEntryButton: View {
    @ObservedObject var entry: Entry
    var showText: Bool = true
    var body: some View {
        Button(action: {
            self.entry.toggleArchive()
        }, label: {
            if showText {
                Label(
                    entry.isArchived ? "Mark as unread" : "Mark as read",
                    systemImage: entry.isArchived ? "book.fill" : "book"
                )
            } else {
                EntryPictoImage(entry: entry, keyPath: \.isArchived, picto: "book")
            }
        })
    }
}
