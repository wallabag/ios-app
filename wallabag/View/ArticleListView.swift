//
//  ArticleListView.swift
//  wallabag
//
//  Created by Marinel Maxime on 11/07/2019.
//

import RealmSwift
import SwiftUI

struct ArticleListView: View {
    @ObjectBinding var entries = BindableResults<Entry>(results: try! Realm().objects(Entry.self))

    var body: some View {
        NavigationView {
            List(entries.results.identified(by: \.id)) { entry in
                NavigationLink(destination: ArticleView(entry: entry)) {
                    ArticleRowView(entry: entry)
                }
            }
            .navigationBarTitle("Articles")
            .navigationBarItems(trailing: Button(action: {}, label: { Image(systemName: "plus") }))
        }
    }
}

#if DEBUG
    struct ArticleListView_Previews: PreviewProvider {
        static var previews: some View {
            ArticleListView()
        }
    }
#endif
