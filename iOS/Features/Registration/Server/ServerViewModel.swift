import Combine
import Foundation
import SwiftUI

class ServerViewModel: ObservableObject {
    @Published private(set) var isValid: Bool = false

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
