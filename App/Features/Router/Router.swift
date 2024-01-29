import Foundation
import Observation
import SwiftUI

@Observable
final class Router {
    var path: [RoutePath] = []
}
