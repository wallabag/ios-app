//
//  TagRow.swift
//  wallabag
//
//  Created by Marinel Maxime on 23/10/2019.
//

import SwiftUI

struct TagRow: View {
    @ObservedObject var tag: Tag
    @ObservedObject var entry: Entry
    @EnvironmentObject var appState: AppState
    @State private var checked: Bool = false

    var body: some View {
        HStack {
            Text(tag.label)
            if checked {
                Spacer()
                Image(systemName: "checkmark")
            }
        }.onTapGesture {
            if self.checked {
                self.appState.session.delete(tag: self.tag, for: self.entry)
                self.checked = false
            } else {
                self.appState.session.add(tag: self.tag.label, for: self.entry)
                self.checked = true
            }
        }.onAppear {
            self.checked = self.entry.tags.contains(self.tag)
            Log(self.entry.tags)
            self.entry.tags.forEach {
                Log(self.tag.label)
                Log($0.label)
                Log(self.$checked.wrappedValue)
                Log(self.entry.tags.contains(self.tag))
                Log("----")
            }
        }
    }
}

struct TagRow_Previews: PreviewProvider {
    static var previews: some View {
        TagRow(tag: Tag(), entry: Entry())
    }
}
