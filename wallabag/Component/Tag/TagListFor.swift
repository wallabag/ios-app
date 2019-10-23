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
    
    func row(tag: Tag) -> some View {
        HStack {
            TagRow(tag: tag)
            if self.entry.tags.contains(tag) {
                Spacer()
                Image(systemName: "checkmark")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List(tagPublisher.tags) { tag in
                self.row(tag: tag).onTapGesture {
                    if self.entry.tags.contains(tag) {
                        self.appState.session.delete(tag: tag, for: self.entry)
                        
                    }
                    self.appState.session.add(tag: tag.label, for: self.entry)
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
