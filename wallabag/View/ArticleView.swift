//
//  ArticleView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import SwiftUI

struct ArticleView: View {
    var entry: Entry!

    var body: some View {
        VStack {
            WebView(entry: entry)
            Spacer()
            HStack {
                Image(systemName: "book")
                Image(systemName: "bookmark")
                Spacer()
                Image(systemName: "trash")
            }
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
