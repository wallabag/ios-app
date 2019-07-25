//
//  ArticleView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import SwiftUI
import RealmSwift

struct ArticleView: View {
    var entry: Entry!

    var body: some View {
        VStack {
            WebView(entry: entry)
            HStack {
                Button(action: {
                    let realm = try? Realm()
                    try? realm?.write {
                        self.entry.isArchived.toggle()
                    }
                }, label: {Image(systemName: entry.isArchived ? "book.fill" : "book")})
                Button(action: {}, label: {Image(systemName: entry.isStarred ? "bookmark.fill" : "bookmark")})
                Spacer()
                Button(action: {}, label: {Image(systemName: "trash")})
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
