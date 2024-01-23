import Foundation
import SwiftUI

enum RoutePath: Hashable {
    case registration
    case addEntry
    case entry(Entry)
    case synthesis(Entry)
    case tags(Entry)
    case tips
    case about
    case setting
    case wallabagPlus
}
