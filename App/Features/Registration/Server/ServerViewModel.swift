import Foundation
import Observation
import SharedLib
import SwiftUI

@Observable
final class ServerViewModel {
    var isValid: Bool {
        validateServer(host: url)
    }

    var url: String = ""

    var shouldGoNextStep = false

    init() {
        url = WallabagUserDefaults.host
    }

    func goNext() {
        WallabagUserDefaults.host = url
        shouldGoNextStep = true
    }

    private func validateServer(host: String) -> Bool {
        host.isValidURL
    }
}
