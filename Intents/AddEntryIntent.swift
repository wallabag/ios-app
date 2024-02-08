import AppIntents
import WallabagKit

struct AddEntryIntent: WallabagIntent {
    static var title: LocalizedStringResource = "Add Entry"

    static var description: IntentDescription = .init("Add entry to your instance")

    @Parameter(title: "Url")
    var url: URL

    static var parameterSummary: some ParameterSummary {
        Summary("Add \(\.$url)")
    }

    func perform() async throws -> some IntentResult {
        _ = try await kit.send(to: WallabagEntryEndpoint.add(url: url.absoluteString))

        return .result()
    }
}
