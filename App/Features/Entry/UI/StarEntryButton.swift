import SwiftUI

struct StarEntryButton: View {
    @ObservedObject var entry: Entry
    var showText: Bool = true
    var body: some View {
        Button(action: {
            entry.toggleStarred()
        }, label: {
            if showText {
                Label(
                    entry.isStarred ? "Unstar" : "Mark as favorite",
                    systemImage: entry.isStarred ? "star.fill" : "star"
                )
            } else {
                EntryPictoImage(entry: entry, keyPath: \.isStarred, picto: "star")
            }
        })
    }
}
