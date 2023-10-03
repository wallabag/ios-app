import Combine
import Foundation
import SwiftUI

final class Router: ObservableObject {
    @Published var path: [RoutePath] = []
}
