//
//  RetrieveModePicker.swift
//  wallabag
//
//  Created by Marinel Maxime on 15/10/2019.
//

import SwiftUI

struct RetrieveModePicker: View {
    @Binding var filter: RetrieveMode
    var body: some View {
        Picker(selection: $filter, label: Text("Filter"), content: {
            Text(RetrieveMode.allArticles.rawValue).tag(RetrieveMode.allArticles)
            Text(RetrieveMode.starredArticles.rawValue).tag(RetrieveMode.starredArticles)
            Text(RetrieveMode.unarchivedArticles.rawValue).tag(RetrieveMode.unarchivedArticles)
            Text(RetrieveMode.archivedArticles.rawValue).tag(RetrieveMode.archivedArticles)
        }).pickerStyle(SegmentedPickerStyle())
    }
}

struct RetrieveModePicker_Previews: PreviewProvider {
    static var previews: some View {
        RetrieveModePicker(filter: .constant(.archivedArticles)).previewLayout(.fixed(width: 300, height: 70))
    }
}
