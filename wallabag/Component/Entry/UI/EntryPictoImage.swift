//
//  EntryArchiveImage.swift
//  wallabag
//
//  Created by Marinel Maxime on 16/10/2019.
//

import SwiftUI

struct EntryPictoImage: View {
    @ObservedObject var entry: Entry
    var keyPath: KeyPath<Entry, Bool>
    var picto: String
    var body: some View {
        Image(systemName: entry[keyPath: keyPath] ? "\(picto).fill" : picto)
    }
}

/*
struct EntryPictoImage_Previews: PreviewProvider {
    static var entryIs: Entry = {
        let entry = Entry()
        entry.isArchived = true
        return entry
    }()

    static var entryNotIs: Entry = {
        let entry = Entry()
        entry.isArchived = false
        return entry
    }()

    static var previews: some View {
        Group {
            EntryPictoImage(entry: entryIs, keyPath: \.isArchived, picto: "book").previewLayout(.fixed(width: 30, height: 30))
            EntryPictoImage(entry: entryNotIs, keyPath: \.isArchived, picto: "book").previewLayout(.fixed(width: 30, height: 30))
            EntryPictoImage(entry: entryNotIs, keyPath: \.isArchived, picto: "star").previewLayout(.fixed(width: 30, height: 30))
        }
    }
}
*/
