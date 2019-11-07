//
//  ServerTextFieldValidator.swift
//  wallabag
//
//  Created by Marinel Maxime on 10/10/2019.
//

import Combine
import Foundation
import SwiftUI

class ServerTextFieldValidator: ObservableObject {
    private(set) var isValid: Bool = false

    @Published var url: String = ""

    private var cancellable: AnyCancellable?

    init() {
        url = WallabagUserDefaults.host
        cancellable = $url.sink { url in
            self.isValid = self.validateServer(string: url)
            if self.isValid {
                WallabagUserDefaults.host = url
            }
        }
    }

    deinit {
        cancellable?.cancel()
    }

    private func validateServer(string: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "(http|https)://", options: [])
            guard let url = URL(string: string),
                UIApplication.shared.canOpenURL(url),
                1 == regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count)).count else {
                return false
            }
            return true
        } catch {
            return false
        }
    }
}
