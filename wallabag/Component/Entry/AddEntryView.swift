//
//  AddEntryView.swift
//  wallabag
//
//  Created by Marinel Maxime on 16/10/2019.
//

import SwiftUI

struct AddEntryView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    @State var url: String = ""

    var body: some View {
        Form {
            TextField("Url", text: $url).autocapitalization(.none).disableAutocorrection(true)
            Button("Submit") {
                self.appState.session.addEntry(url: self.url)
                self.presentationMode.wrappedValue.dismiss()
            }
        }.navigationBarTitle("Server")
    }
}

struct AddEntryView_Previews: PreviewProvider {
    static var previews: some View {
        AddEntryView(url: "")
    }
}
