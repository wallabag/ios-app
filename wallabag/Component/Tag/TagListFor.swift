//
//  TagListFor.swift
//  wallabag
//
//  Created by Marinel Maxime on 23/10/2019.
//

import CoreData
import SwiftUI

struct TagListFor: View {
    @ObservedObject var entry: Entry
    @EnvironmentObject var appState: AppState
    @State private var tagLabel: String = ""

    @FetchRequest(fetchRequest: Tag.fetchRequestSorted()) var tags: FetchedResults

    var body: some View {
        VStack {
            Text("Tag").font(.largeTitle).bold()
            HStack {
                TextField("New tag", text: $tagLabel)
                Button(action: {
                    self.appState.session.add(tag: self.tagLabel, for: self.entry)
                }, label: { Text("Send") })
            }.padding()
            List(tags) { tag in
                TagRow(tag: tag, entry: self.entry)
            }
        }
    }
}

struct TagListFor_Previews: PreviewProvider {
    static var previews: some View {
        TagListFor(entry: Entry())
    }
}
