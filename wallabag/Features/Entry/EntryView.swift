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
            PlayerView()
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
        HStack(alignment: .bottom) {
            DeleteEntryButton(showConfirm: $showDeleteConfirm, showText: false).hapticNotification(.warning)
            Group {
                Spacer()
                FontSizeSelectorView()
                    .buttonStyle(PlainButtonStyle())
                Spacer()
            }
            Group {
                Button(action: {
                    appSync.refresh(entry: entry)
                }, label: {
                    Image(systemName: "arrow.counterclockwise")
                }).buttonStyle(PlainButtonStyle())
                Spacer()
                Button(action: {
                    self.openInSafari(self.entry.url)
                }, label: {
                    Image(systemName: "safari")
                }).buttonStyle(PlainButtonStyle())
            }
            Group {
                Spacer()
                Button(action: {
                    self.showTag.toggle()
                }, label: {
                    Image(systemName: self.showTag ? "tag.fill" : "tag")
                }).buttonStyle(PlainButtonStyle())
                Spacer()
            }
            Button(action: {
                player.load(entry)
            }, label: {
                Text("Load player")
            })
            StarEntryButton(entry: entry, showText: false).hapticNotification(.success)
            Spacer()
            ArchiveEntryButton(entry: entry, showText: false).hapticNotification(.success)
        }.font(.system(size: 20))
            .padding()
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
