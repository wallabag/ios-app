import Combine
import Foundation
import Observation

@Observable
final class ErrorViewModel {
    private var resetAfter: Double
    private(set) var lastError: WallabagError?

    init(_ resetAfter: Double = 10) {
        self.resetAfter = resetAfter
    }

    func setLast(_ error: WallabagError) {
        lastError = error
        Task.detached { [weak self] in
            guard let self else { return }
            try? await Task.sleep(for: .seconds(resetAfter))
            lastError = nil
        }
    }
}
