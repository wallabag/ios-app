import Combine
import Foundation
import SharedLib
import SwiftUI

final class ServerViewModel: ObservableObject {
    @Published private(set) var isValid: Bool = false
    @Published var url: String = ""

    private var cancellable: AnyCancellable?

    init() {
        url = WallabagUserDefaults.host
        cancellable = $url.sink { [unowned self] url in
            isValid = validateServer(host: url)
            if isValid {
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
