//
//  AddEntryView.swift
//  wallabag
//
//  Created by Marinel Maxime on 16/10/2019.
//

import SwiftUI

struct AddEntryView: View {
    @EnvironmentObject var appState: AppState
    @State private var url: String = ""

    var body: some View {
        Form {
            TextField("Url", text: $url).autocapitalization(.none).disableAutocorrection(true)
            Button("Submit") {
                #warning("Need to be rework... progress, status result")
                self.appState.session.addEntry(url: self.url)
            }
        }.navigationBarTitle("Add url")
    }
}

struct AddEntryView_Previews: PreviewProvider {
    static var previews: some View {
        AddEntryView()
    }
}
