//
//  ServerTextFieldValidator.swift
//  wallabag
//
//  Created by Marinel Maxime on 10/10/2019.
//

import Combine
import Foundation
import SwiftUI

class ServerViewModel: ObservableObject {
    private(set) var isValid: Bool = false

    @Published var url: String = ""

    private var cancellable: AnyCancellable?

    init() {
        url = WallabagUserDefaults.host
        cancellable = $url.sink { [unowned self] url in
            self.isValid = self.validateServer(host: url)
            if self.isValid {
                WallabagUserDefaults.host = url
            }
        }
    }

    deinit {
        cancellable?.cancel()
    }

    private func validateServer(host: String) -> Bool {
        host.isValidURL
    }
}
