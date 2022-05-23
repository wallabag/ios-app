import Combine
import Foundation

final class Router: ObservableObject {
    @Published private(set) var route: Route = .registration

    init(defaultRoute: Route) {
        load(defaultRoute)
    }

    func load(_ route: Route) {
        logger.info("Load route \(route.id)")
        self.route = route
    }
}
