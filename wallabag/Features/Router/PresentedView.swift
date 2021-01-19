import Foundation
import SwiftUI

@available(*, deprecated, message: "Remove this old view presenter")
struct PresentedView: Identifiable {
    let id: String
    let wrappedView: AnyView
}
