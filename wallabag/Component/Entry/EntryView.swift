//
//  ArticleView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import CoreData
import SwiftUI

struct EntryView: View {
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
                Text(entry.title ?? "Entry")
                    .font(.title)
                    .fontWeight(.black)
                    .lineLimit(1)
                Spacer()
            }.padding()
            WebView(entry: entry)
            HStack {
                DeleteEntryButton(entry: entry, showText: false) {
                    self.router.load(.entries)
                }.hapticNotification(.warning)
                Spacer()
                Button(action: {
                    self.showTag.toggle()
                }, label: {
                    Image(systemName: self.showTag ? "tag.fill" : "tag")
                }).buttonStyle(PlainButtonStyle())
                StarEntryButton(entry: entry, showText: false).hapticNotification(.success)
                ArchiveEntryButton(entry: entry, showText: false).hapticNotification(.success)
            }.font(.system(size: 20))
                .padding()
            // PlayerView()
        }.sheet(isPresented: $showTag) {
            TagListFor(tagsForEntry: TagsForEntryPublisher(entry: self.entry))
                .environment(\.managedObjectContext, CoreData.shared.viewContext)
        }
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
