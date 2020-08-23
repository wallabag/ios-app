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
    @State private var submitting: Bool = false

    var body: some View {
        Form {
            TextField("Url", text: $url)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            HStack {
                Button(submitting ? "Submitting..." : "Submit") {
                    self.submitting = true
                    self.appState.session.addEntry(url: self.url) {
                        self.submitting = false
                    }
                }.disabled(submitting)
            }
        }.navigationBarTitle("Add url")
    }
}

struct AddEntryView_Previews: PreviewProvider {
    static var previews: some View {
        AddEntryView()
    }
}
