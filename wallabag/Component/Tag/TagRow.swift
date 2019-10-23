//
//  TagRow.swift
//  wallabag
//
//  Created by Marinel Maxime on 23/10/2019.
//

import SwiftUI

struct TagRow: View {
    @ObservedObject var tag: Tag
    var body: some View {
        Text(tag.label)
    }
}

struct TagRow_Previews: PreviewProvider {
    static var previews: some View {
        TagRow(tag: Tag())
    }
}
