//
//  ClientIdClientServerTextFieldValidator.swift
//  wallabag
//
//  Created by Marinel Maxime on 10/10/2019.
//

import Combine
import Foundation
import SwiftUI

class ClientIdClientSecretTextFieldValidator: ObservableObject {
    private(set) var isValid: Bool = false

    @Published var clientId: String = ""
    @Published var clientSecret: String = ""

    private var cancellable: AnyCancellable?

    init() {
        clientId = WallabagUserDefaults.clientId
        clientSecret = WallabagUserDefaults.clientSecret

        cancellable = Publishers.CombineLatest($clientId, $clientSecret).sink { clientId, clientSecret in
            self.isValid = !clientId.isEmpty && !clientSecret.isEmpty
            if self.isValid {
                WallabagUserDefaults.clientId = clientId
                WallabagUserDefaults.clientSecret = clientSecret
            }
        }
    }

    deinit {
        cancellable?.cancel()
    }
}
