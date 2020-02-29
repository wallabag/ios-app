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
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var playerPublisher: PlayerPublisher
    @State var showTag: Bool = false

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.router.route = .entries
                }, label: {
                    Text("Back")
                })
                Text(entry.title ?? "Entry")
                    .fontWeight(.black)
                    .lineLimit(1)
                Spacer()
            }.padding(.horizontal)
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
                    self.router.route = .entries
                }
            }
            .padding()
            PlayerView()
        }
    }
}

#if DEBUG
    struct EntryView_Previews: PreviewProvider {
        static var previews: some View {
            EntryView(entry: Entry())
        }
    }
#endif
