//
//  TagRow.swift
//  wallabag
//
//  Created by Marinel Maxime on 23/10/2019.
//

import SwiftUI
import SwiftyLogger

struct TagRow: View {
    @ObservedObject var tag: Tag
    @ObservedObject var tagsForEntry: TagsForEntryPublisher

    var body: some View {
        HStack {
            Text(tag.label)
            if tag.isChecked {
                Spacer()
                Image(systemName: "checkmark")
            }
        }.onTapGesture {
            if self.tag.isChecked {
                self.tagsForEntry.delete(tag: self.tag)
            } else {
                self.tagsForEntry.add(tag: self.tag)
            }
        }
    }
}

/*
 struct TagRow_Previews: PreviewProvider {
 static var previews: some View {
     TagRow(tag: Tag(), entry: Entry())
 }
 }
 */
