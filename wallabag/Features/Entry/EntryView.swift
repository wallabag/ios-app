import CoreData
import HTMLEntities
import SwiftUI

struct EntryView: View {
    @EnvironmentObject var appSync: AppSync
    @EnvironmentObject var router: Router
    @ObservedObject var entry: Entry
    @State var showTag: Bool = false

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
            // PlayerView()
        }.sheet(isPresented: $showTag) {
            TagListFor(tagsForEntry: TagsForEntryPublisher(entry: self.entry))
                .environment(\.managedObjectContext, CoreData.shared.viewContext)
        }
    }

    private var bottomBar: some View {
        HStack(alignment: .bottom) {
            DeleteEntryButton(entry: entry, showText: false) {
                self.router.load(.entries)
            }.hapticNotification(.warning)
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
            Spacer()
            Button(action: {
                self.showTag.toggle()
            }, label: {
                Image(systemName: self.showTag ? "tag.fill" : "tag")
            }).buttonStyle(PlainButtonStyle())
            Spacer()
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
