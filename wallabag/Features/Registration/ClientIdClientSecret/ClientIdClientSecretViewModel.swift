import Combine
import Foundation
import SwiftUI

class ClientIdSecretViewModel: ObservableObject {
    private(set) var isValid: Bool = false

    @Published var clientId: String = ""
    @Published var clientSecret: String = ""

    private var cancellable: AnyCancellable?

    init() {
        clientId = WallabagUserDefaults.clientId
        clientSecret = WallabagUserDefaults.clientSecret

        cancellable = Publishers.CombineLatest($clientId, $clientSecret).sink { [unowned self] clientId, clientSecret in
            self.isValid = !clientId.isEmpty && !clientSecret.isEmpty
            if self.isValid {
                WallabagUserDefaults.clientId = clientId.trimmingCharacters(in: .whitespacesAndNewlines)
                WallabagUserDefaults.clientSecret = clientSecret.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
    }

    deinit {
        cancellable?.cancel()
    }
}
