//
//  ServerTextFieldValidator.swift
//  wallabag
//
//  Created by Marinel Maxime on 10/10/2019.
//

import Foundation
import SwiftUI

class ServerTextFieldValidator: ObservableObject {
    @Published var isValid: Bool = false {
        didSet {
            if isValid {
                WallabagUserDefaults.host = url
            }
        }
    }

    var url: String = "" {
        didSet {
            handle(url: url)
        }
    }

    init() {
        url = WallabagUserDefaults.host
        handle(url: url)
    }

    private func handle(url: String) {
        isValid = validateServer(string: url)
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
