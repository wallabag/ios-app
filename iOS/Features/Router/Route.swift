import Foundation
import SwiftUI

enum RoutePath: Hashable {
    case registration
    case addEntry
    case entry(Entry)
    case tips
    case about
    case setting
}
