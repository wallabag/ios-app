import Combine
import Foundation

enum Route {
    case registration

    var id: String {
        switch self {
        case .registration:
            return "registration"
        }
    }
}
