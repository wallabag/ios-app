import Foundation

enum WallabagError: Error {
    case syncError(String)
    case wallabagKitError(Error)
}

extension WallabagError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case let .syncError(error):
            "\(error)"
        case let .wallabagKitError(error):
            switch error {
            // case let .jsonError(json):
            //    return json.errorDescription
            default:
                error.localizedDescription
            }
        }
    }
}
