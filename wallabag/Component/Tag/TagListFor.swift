//
//  TagListFor.swift
//  wallabag
//
//  Created by Marinel Maxime on 23/10/2019.
//

import SwiftUI

struct TagListFor: View {
    @ObservedObject var tagPublisher: TagPublisher = TagPublisher()
    @ObservedObject var entry: Entry
    @EnvironmentObject var appState: AppState
    @State private var tagLabel: String = ""

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("New tag", text: $tagLabel)
                    Button(action: {
                        self.appState.session.add(tag: self.tagLabel, for: self.entry)
                    }, label: { Text("Send") })
                }.padding()
                List(tagPublisher.tags) { tag in
                    TagRow(tag: tag, entry: self.entry)
                }
            }.navigationBarTitle("Tag")
        }
    }
}

struct TagListFor_Previews: PreviewProvider {
    static var previews: some View {
        TagListFor(entry: Entry())
    }
}
