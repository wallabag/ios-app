import CoreData
import Factory
import HTMLEntities
import SwiftUI

struct EntryView: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appSync: AppSync
    @EnvironmentObject var player: PlayerPublisher
    @ObservedObject var entry: Entry
    @State var showTag: Bool = false
    @State private var showDeleteConfirm = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.title?.htmlUnescape() ?? "Entry")
                .font(.title)
                .fontWeight(.black)
                .lineLimit(2)
                .padding(.horizontal)
            WebView(entry: entry)
            bottomBar
        }
        .sheet(isPresented: $showTag) {
            TagListFor(tagsForEntry: TagsForEntryPublisher(entry: self.entry))
                .environment(\.managedObjectContext, context)
        }
        .actionSheet(isPresented: $showDeleteConfirm) {
            ActionSheet(
                title: Text("Confirm delete?"),
                buttons: [
                    .destructive(Text("Delete")) {
                        self.context.delete(entry)
                        dismiss()
                    },
                    .cancel(),
                ]
            )
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var bottomBar: some View {
        HStack {
            FontSizeSelectorView()
                .buttonStyle(PlainButtonStyle())
            Spacer()
            SwiftUI.Menu(content: {
                Button(action: {
                    self.showDeleteConfirm = true
                }, label: {
                    Label("Delete", systemImage: "trash")
                })
                Button(action: {
                    openURL(self.entry.url!.url!)
                }, label: {
                    Label("Open in Safari", systemImage: "safari")
                })
                Button(action: {
                    self.showTag.toggle()
                }, label: {
                    Label("Tag", systemImage: self.showTag ? "tag.fill" : "tag")
                })
                Button(action: {
                    appSync.refresh(entry: entry)
                }, label: {
                    Label("Refresh", systemImage: "arrow.counterclockwise")
                })
                StarEntryButton(entry: entry, showText: true).hapticNotification(.success)
                ArchiveEntryButton(entry: entry, showText: true).hapticNotification(.success)
                Button(action: {
                    player.load(entry)
                }, label: {
                    Label("Load entry", systemImage: "music.note")
                })
                .accessibilityHint("Load entry in text-to-speech player")
            }, label: {
                Label("Entry option", systemImage: "filemenu.and.selection")
                    .foregroundColor(.primary)
                    .labelStyle(.iconOnly)
                    .frame(width: 28, height: 28)
            }).accessibilityLabel("Entry option")
        }.padding(.horizontal)
    }
}

#if DEBUG
    struct EntryView_Previews: PreviewProvider {
        static var previews: some View {
            let coreData = Container.shared.coreData()
            EntryView(entry: Entry(context: coreData.viewContext))
                .environmentObject(PlayerPublisher())
                .environment(\.managedObjectContext, coreData.viewContext)
        }
    }
#endif
