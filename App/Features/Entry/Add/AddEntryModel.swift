import Factory
import Foundation
import Observation
import SwiftUI

@Observable
final class AddEntryModel {
    @ObservationIgnored
    @Injected(\.wallabagSession) private var session

    var url: String = ""
    var submitting: Bool = false
    var succeeded: Bool = false

    @MainActor
    func addEntry() async {
        defer {
            submitting = false
            succeeded = false
            url = ""
        }

        submitting = true
        do {
            try await session.addEntry(url: url)
            succeeded = true
            try await Task.sleep(for: .seconds(3))
        } catch {}
    }
}
