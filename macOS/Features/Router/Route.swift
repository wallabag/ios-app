import Foundation
import SwiftUI

enum Route {
    case registration
    case entry(Entry)

    var id: String {
        switch self {
        case .registration:
            return "registration"
        case .entry:
            return "entry"
        }
    }

    @ViewBuilder
    var view: some View {
        switch self {
        case .registration:
            RegistrationView()
        default:
            Text("test")
        }
    }
}
