//
//  ArticleListView.swift
//  wallabag
//
//  Created by Marinel Maxime on 11/07/2019.
//

import RealmSwift
import SwiftUI

struct ArticleListView: View {
    enum Filter {
        case unarchived
    }
    @EnvironmentObject var appSync: AppSync
    @ObservedObject var entries = BindableResults<Entry>(results: try! Realm().objects(Entry.self))
    @State var filter: Filter = .unarchived

    var body: some View {
        NavigationView {
            VStack {
                /*SegmentedControl(selection: $filter) {
                    Text("All").tag(3)
                    Text("Read").tag(0)
                    Text("Starred").tag(1)
                    Text("Unread").tag(2)
            }*/
            List(entries.results, id: \.id) { entry in
                NavigationLink(destination: ArticleView(entry: entry)) {
                    ArticleRowView(entry: entry)
                }
            }
            .navigationBarTitle("Articles")
            .navigationBarItems(trailing:
                ViewBuilder.buildBlock(
                    HStack {
                        Button(
                            action: {
                                self.appSync.requestSync()
                            },
                            label: {
                                Image(systemName: "arrow.counterclockwise")
                            }
                        ).disabled(appSync.inProgress)
                        NavigationLink(destination: StubView(), label: {Image(systemName: "plus")})
                    }
                )
            )
            }
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
