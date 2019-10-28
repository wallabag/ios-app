//
//  ArticleListView.swift
//  wallabag
//
//  Created by Marinel Maxime on 11/07/2019.
//

import CoreData
import SwiftUI

struct ArticlesView: View {
    @EnvironmentObject var appSync: AppSync
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var entryPublisher: EntryPublisher
    @State private var retrieveMode: RetrieveMode = .allArticles

    var body: some View {
        NavigationView {
            VStack {
                RetrieveModePicker(filter: $retrieveMode)
                // WORKAROUND TO fetchRequest
                if retrieveMode == .starredArticles {
                    StarredArticleListView()
                }
                if retrieveMode == .unarchivedArticles {
                    UnarchivedArticleListView()
                }
                if retrieveMode == .archivedArticles {
                    ArchivedArticleListView()
                }
                if retrieveMode == .allArticles {
                    AllArticlesListView()
                }
            }
            .navigationBarTitle("Articles")
            .navigationBarItems(trailing:
                ViewBuilder.buildBlock(
                    HStack {
                        RefreshButton()
                        NavigationLink(destination: AddEntryView(), label: { Image(systemName: "plus") })
                    }
            ))
        }
    }
}

#if DEBUG
    struct ArticleListView_Previews: PreviewProvider {
        static var previews: some View {
            ArticlesView()
        }
    }
#endif
