//
//  ArticleView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import CoreData
import SwiftUI

struct EntryView: View {
    @ObservedObject var entry: Entry
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var playerPublisher: PlayerPublisher
    @Environment(\.presentationMode) var presentationMode
    @State var showTag: Bool = false

    var body: some View {
        VStack {
            WebView(entry: entry)
            if showTag {
                TagListFor(entry: entry)
            }
            HStack {
                ArchiveEntryButton(entry: entry, showText: false)
                StarEntryButton(entry: entry, showText: false)
                Button(action: {
                    self.showTag.toggle()
                }, label: {
                    Image(systemName: self.showTag ? "tag.fill" : "tag")
                })
                Button(action: {
                    self.playerPublisher.load(self.entry)
                    self.appState.showPlayer = true
                }, label: {
                    Image(systemName: "music.note.list")
                })
                Spacer()
                DeleteEntryButton(entry: entry, showText: false) {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }.padding()
        }.navigationBarTitle(entry.title ?? "")
    }
}

#if DEBUG
    struct EntryView_Previews: PreviewProvider {
        static var previews: some View {
            EntryView(entry: Entry())
        }
    }
#endif
