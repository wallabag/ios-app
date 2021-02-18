import Foundation
import SwiftUI

struct Menu: Identifiable {
    var id: String {
        "\(route.title)"
    }

    let title: LocalizedStringKey
    let img: String
    let route: Route
}
