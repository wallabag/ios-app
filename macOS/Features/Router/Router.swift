import Combine
import Foundation

final class Router: ObservableObject {
    static var shared = Router()

    @Published private(set) var route: Route = .registration

    private init() {}

    func load(_ route: Route) {
        logger.info("Load route \(route.id)")
        self.route = route
    }
}
