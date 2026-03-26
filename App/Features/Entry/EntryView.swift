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
        WebView(entry: entry, progress: $progress)
            .ignoresSafeArea()
            .safeAreaInset(edge: .top) {
                ProgressView(value: max(0, min(progress, 1)), total: 1)
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
        .alert("Confirm delete?", isPresented: $showDeleteConfirm) {
            Button(role: .destructive, action: {
                context.delete(entry)
                dismiss()
            }, label: {
                Text("Delete")
            })
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showTag) {
            TagListFor(entry: entry)
                .presentationDetents([.medium, .large])
        }
        .toolbarBackground(.ultraThinMaterial, for: .bottomBar)
        .toolbarBackground(.visible, for: .bottomBar)
        .ignoresSafeArea(.all, edges: .bottom)
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
        if let url = entry.url?.url {
            ShareLink(item: url) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        }
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
