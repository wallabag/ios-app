//
//  ClientIdClientSecretView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import Combine
import SwiftUI

class ClientIdClientSecretHandler: ObservableObject {
    @Published var isValid: Bool = false {
        didSet {
            WallabagUserDefaults.clientId = clientId
            WallabagUserDefaults.clientSecret = clientSecret
        }
    }

    var clientId: String = "" {
        didSet {
            validate()
        }
    }

    var clientSecret: String = "" {
        didSet {
            validate()
        }
    }

    init() {
        clientId = WallabagUserDefaults.clientId
        clientSecret = WallabagUserDefaults.clientSecret
    }

    private func validate() {
        isValid = !clientId.isEmpty && !clientSecret.isEmpty
    }
}

struct ClientIdClientSecretView: View {
    @ObservedObject var clientIdClientSecretHandler = ClientIdClientSecretHandler()

    var body: some View {
        Form {
            Section(header: Text("Client id")) {
                TextField("Client id", text: $clientIdClientSecretHandler.clientId)
            }
            Section(header: Text("Client secret")) {
                TextField("Client secret", text: $clientIdClientSecretHandler.clientSecret)
            }
            NavigationLink("Next", destination: LoginView()).disabled(!clientIdClientSecretHandler.isValid)
        }.navigationBarTitle("Client id & secret")
    }
}

#if DEBUG
    struct ClientIdClientSecretView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                ClientIdClientSecretView()
            }
        }
    }
#endif
