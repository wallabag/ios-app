import Foundation
import Observation
import SharedLib

@Observable
final class ClientIdSecretViewModel {
    var isValid: Bool {
        !clientId.isEmpty && !clientSecret.isEmpty
    }

    var clientId: String = ""
    var clientSecret: String = ""
    var shouldGoNextStep = false

    init() {
        clientId = WallabagUserDefaults.clientId
        clientSecret = WallabagUserDefaults.clientSecret
    }

    func goNext() {
        WallabagUserDefaults.clientId = clientId.trimmingCharacters(in: .whitespacesAndNewlines)
        WallabagUserDefaults.clientSecret = clientSecret.trimmingCharacters(in: .whitespacesAndNewlines)
        shouldGoNextStep = true
    }
}
