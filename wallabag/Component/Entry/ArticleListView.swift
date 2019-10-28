//
//  ArticleListView.swift
//  wallabag
//
//  Created by Marinel Maxime on 27/10/2019.
//

import Foundation
import SwiftUI

struct ArticleListView: View {
    @Binding var entries: FetchedResults<Entry>
    var body: some View {
        List {
            ForEach(entries, id: \.objectID) { entry in
                NavigationLink(destination: ArticleView(entry: .constant(entry))) {
                    ArticleRowView(entry: .constant(entry))
                        .contextMenu {
                            ArchiveEntryButton(entry: .constant(entry))
                            StarEntryButton(entry: .constant(entry))
                            DeleteEntryButton(entry: entry)
                        }
                }
            }
        }
    }
}
