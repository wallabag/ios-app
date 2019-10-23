//
//  ArticleTableView.swift
//  wallabag
//
//  Created by Marinel Maxime on 22/10/2019.
//

import SwiftUI

struct ArticleTableView: View {
    @Binding var entries: [Entry]
    @EnvironmentObject var appState: AppState
    var body: some View {
        List {
            ForEach(entries) { entry in
                NavigationLink(destination: ArticleView(entry: entry) ){
                    ArticleRowView(entry: entry)
                        .contextMenu {
                            ArchiveEntryButton(entry: entry)
                            StarEntryButton(entry: entry)
                            DeleteEntryButton(entry: entry)
                    }
                }
            }
        }
    }
}

struct ArticleTableView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleTableView(entries: .constant([Entry()]))
    }
}
