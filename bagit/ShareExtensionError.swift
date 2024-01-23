import Foundation

enum ShareExtensionError: Error, LocalizedError {
    case unregistredApp
    case authError
    case retrievingURL
    case duringAdding

    var localizedDescription: String {
        switch self {
        case .unregistredApp:
            "App not registred or configured"
        case .authError:
            "Error during auth"
        case .retrievingURL:
            "Error retrieve url from extension"
        case .duringAdding:
            "Error during pushing to your wallabag server"
        }
    }
}
