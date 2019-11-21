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
    @EnvironmentObject var entryPublisher: EntryPublisher
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var playerPublisher: PlayerPublisher
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
                Spacer()
                Button(action: {
                    self.playerPublisher.load(self.entry)
                    self.appState.showPlayer = true
                }, label: {
                    Image(systemName: "ear")
                })
                DeleteEntryButton(entry: entry, showText: false)
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
