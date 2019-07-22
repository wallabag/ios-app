//
//  ClientIdClientSecretView.swift
//  wallabag
//
//  Created by Marinel Maxime on 18/07/2019.
//

import SwiftUI
import Combine

class ClientIdClientSecretValidator: BindableObject {
    let didChange = PassthroughSubject<Void, Never>()
    var isValid: Bool = false {
        didSet {
            didChange.send()
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
    
    private func validate(){
        isValid = !clientId.isEmpty && !clientSecret.isEmpty
    }
}

struct ClientIdClientSecretView: View {
    @ObjectBinding var clientIdClientSecretValidator = ClientIdClientSecretValidator()
    
    var body: some View {
        Form {
            Section(header: Text("Client id")) {
                TextField($clientIdClientSecretValidator.clientId)
            }
            Section(header: Text("Client secret")) {
                TextField($clientIdClientSecretValidator.clientSecret)
            }
            NavigationLink("Next", destination: LoginView()).disabled(!clientIdClientSecretValidator.isValid)
        }
    }
}

#if DEBUG
struct ClientIdClientSecretView_Previews: PreviewProvider {
    static var previews: some View {
        ClientIdClientSecretView()
    }
}
#endif
