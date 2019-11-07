//
//  ServerView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import SwiftUI

struct ServerView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var serverValidator = ServerTextFieldValidator()

    var body: some View {
        Form {
            Section(header: Text("Server")) {
                TextField("Server", text: $serverValidator.url).disableAutocorrection(true).autocapitalization(.none)
            }
            NavigationLink(destination: ClientIdClientSecretView()) {
                Text("Next")
            }.disabled(!serverValidator.isValid)
        }.navigationBarTitle("Server")
    }
}

#if DEBUG
    struct ServerView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                ServerView().environmentObject(AppState())
            }
        }
    }
#endif
