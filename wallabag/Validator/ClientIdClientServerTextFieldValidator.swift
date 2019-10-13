//
//  ClientIdClientServerTextFieldValidator.swift
//  wallabag
//
//  Created by Marinel Maxime on 10/10/2019.
//

import Foundation
import SwiftUI

class ClientIdClientSecretTextFieldValidator: ObservableObject {
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
        validate()
    }

    private func validate() {
        isValid = !clientId.isEmpty && !clientSecret.isEmpty
    }
}
