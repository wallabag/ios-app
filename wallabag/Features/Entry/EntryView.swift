import CoreData
import HTMLEntities
import SwiftUI

struct EntryView: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @EnvironmentObject var appSync: AppSync
    @EnvironmentObject var router: Router
    @EnvironmentObject var player: PlayerPublisher
    @ObservedObject var entry: Entry
    @State var showTag: Bool = false
    @State private var showDeleteConfirm = false

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.router.load(.entries)
                }, label: {
                    Text("Back")
                })
                Text(entry.title?.htmlUnescape() ?? "Entry")
                    .font(.title)
                    .fontWeight(.black)
                    .lineLimit(1)
                Spacer()
            }.padding()
            WebView(entry: entry)
            bottomBar
        }.sheet(isPresented: $showTag) {
            TagListFor(tagsForEntry: TagsForEntryPublisher(entry: self.entry))
                .environment(\.managedObjectContext, CoreData.shared.viewContext)
        }
        .actionSheet(isPresented: $showDeleteConfirm) {
            ActionSheet(
                title: Text("Confirm delete?"),
                buttons: [
                    .destructive(Text("Delete")) {
                        self.context.delete(entry)
                        self.router.load(.entries)
                    },
                    .cancel(),
                ]
            )
        }
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
                    self.openInSafari(self.entry.url)
                }, label: {
                    Label("Open in safari", systemImage: "safari")
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
            }, label: {
                Image(systemName: "filemenu.and.selection").foregroundColor(.primary)
            })
        }.padding()
    }
}

#if DEBUG
    struct EntryView_Previews: PreviewProvider {
        static var previews: some View {
            EntryView(entry: Entry(context: CoreData.shared.viewContext))
                .environmentObject(PlayerPublisher())
                .environmentObject(Router())
                .environment(\.managedObjectContext, CoreData.shared.viewContext)
        }
    }
#endif
