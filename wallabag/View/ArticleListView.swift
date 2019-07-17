//
//  ArticleListView.swift
//  wallabag
//
//  Created by Marinel Maxime on 11/07/2019.
//

import SwiftUI
import RealmSwift

struct ArticleListView : View {
    @ObjectBinding var entries = BindableResults<Entry>(results: try! Realm().objects(Entry.self))

    var body: some View {
        List(entries.results.identified(by: \.id)) { entry in
            ArticleRowView(entry: entry)
        }
    }
}

#if DEBUG
struct ArticleListView_Previews : PreviewProvider {
    static var previews: some View {
        ArticleListView()
    }
}
#endif
