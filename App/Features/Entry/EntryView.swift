import CoreData
import Factory
import HTMLEntities
import SwiftUI

struct EntryView: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) private var dismiss
    @Environment(AppSync.self) var appSync: AppSync
    #if os(iOS)
        @Environment(PlayerPublisher.self) var player: PlayerPublisher
    #endif
    @ObservedObject var entry: Entry
    @State var showTag: Bool = false
    @State private var showDeleteConfirm = false
    @State private var progress = 0.0

    #if os(iOS)
        let toolbarPlacement: ToolbarItemPlacement = .bottomBar
    #else
        let toolbarPlacement: ToolbarItemPlacement = .primaryAction
    #endif

    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.title?.htmlUnescape() ?? "Entry")
                .font(.title)
                .fontWeight(.black)
                .lineLimit(2)
                .padding(.horizontal)
            ProgressView(value: progress, total: 1)
            WebView(entry: entry, progress: $progress)
        }
        .addSwipeToBack {
            dismiss()
        }
        .toolbar {
            ToolbarItem(placement: toolbarPlacement) {
                Menu(content: {
                    bottomBarButton
                }, label: {
                    Label("Entry option", systemImage: "filemenu.and.selection")
                        .foregroundColor(.primary)
                        .labelStyle(.iconOnly)
                })
                .accessibilityLabel("Entry option")
                .frame(width: 28, height: 28)
                .contentShape(Rectangle())
            }
            ToolbarItem(placement: toolbarPlacement) {
                FontSizeSelectorView()
                    .buttonStyle(.plain)
            }
            ToolbarItem(placement: toolbarPlacement) {
                Menu(content: {
                    NavigationLink(value: RoutePath.synthesis(entry), label: {
                        Text("Synthesis")
                    })
                    NavigationLink(value: RoutePath.tags(entry), label: {
                        Text("Suggest tag")
                    })
                }, label: {
                    Label("Help assistant", systemImage: "hands.and.sparkles")
                        .foregroundColor(.primary)
                        .labelStyle(.iconOnly)
                })
            }
        }
        .actionSheet(isPresented: $showDeleteConfirm) {
            ActionSheet(
                title: Text("Confirm delete?"),
                buttons: [
                    .destructive(Text("Delete")) {
                        context.delete(entry)
                        dismiss()
                    },
                    .cancel(),
                ]
            )
        }
        .sheet(isPresented: $showTag) {
            TagListFor(tagsForEntry: TagsForEntryPublisher(entry: entry))
                .environment(\.managedObjectContext, context)
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    @ViewBuilder
    private var bottomBarButton: some View {
        Button(role: .destructive, action: {
            showDeleteConfirm = true
        }, label: {
            Label("Delete", systemImage: "trash")
        })
        Divider()
        Button(action: {
            openURL(entry.url!.url!)
        }, label: {
            Label("Open in Safari", systemImage: "safari")
        })
        Button(action: {
            showTag.toggle()
        }, label: {
            Label("Tag", systemImage: showTag ? "tag.fill" : "tag")
        })
        Button(action: {
            appSync.refresh(entry: entry)
        }, label: {
            Label("Refresh", systemImage: "arrow.counterclockwise")
        })
        StarEntryButton(entry: entry, showText: true)
        #if os(iOS)
            .hapticNotification(.success)
        #endif
        ArchiveEntryButton(entry: entry, showText: true) {
            dismiss()
        }
        #if os(iOS)
        .hapticNotification(.success)
        #endif
        #if os(iOS)
            Button(action: {
                player.load(entry)
            }, label: {
                Label("Load entry", systemImage: "music.note")
            })
            .accessibilityHint("Load entry in text-to-speech player")
        #endif
    }
}

#if DEBUG
    struct EntryView_Previews: PreviewProvider {
        static var previews: some View {
            let coreData = Container.shared.coreData()
            EntryView(entry: Entry(context: coreData.viewContext))
            #if os(iOS)
                .environment(PlayerPublisher())
            #endif
                .environment(\.managedObjectContext, coreData.viewContext)
        }
    }
#endif
