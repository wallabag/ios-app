//
//  ArticleView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import RealmSwift
import SwiftUI

struct ArticleView: View {
    @ObservedObject var entry: Entry
    @EnvironmentObject var entryPublisher: EntryPublisher

    var body: some View {
        VStack {
            WebView(entry: entry)
            HStack {
                ArchiveEntryButton(entry: entry, showText: false)
                StarEntryButton(entry: entry, showText: false)
                Spacer()
                DeleteEntryButton(entry: entry, showText: false)
            }.padding()
        }.navigationBarTitle(entry.title ?? "")
    }
}


 #if DEBUG
 struct ArticleView_Previews: PreviewProvider {
     static var previews: some View {
         ArticleView(entry: Entry())
     }
 }
 #endif
