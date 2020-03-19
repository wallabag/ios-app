//
//  ServerView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import SwiftUI

struct ServerView: View {
    @ObservedObject var serverViewHandler = RegistrationServerViewHandler()

    var body: some View {
        Form {
            Section(header: Text("Server")) {
                TextField("https://your-instance.domain", text: $serverViewHandler.url)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }
            NavigationLink(destination: ClientIdClientSecretView()) {
                Text("Next")
            }.disabled(!serverViewHandler.isValid)
        }.navigationBarTitle("Server")
    }
}

#if DEBUG
    struct ServerView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                ServerView()
            }
        }
    }
#endif
