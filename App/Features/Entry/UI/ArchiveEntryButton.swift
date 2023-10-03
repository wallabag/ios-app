import SwiftUI

struct ArchiveEntryButton: View {
    @ObservedObject var entry: Entry
    let showText: Bool
    let action: (() -> Void)?

    init(entry: Entry, showText: Bool = true, action: (() -> Void)? = nil) {
        self.entry = entry
        self.showText = showText
        self.action = action
    }

    var body: some View {
        Button(action: {
            entry.toggleArchive()
            action?()
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
