import Combine
import Foundation
import SwiftUI

final class Router: ObservableObject {
    static var shared = Router()

    @Injector private var appState: AppState

    @Published var currentView: PresentedView?

    private(set) var route: Route = .registration

    init() {
        if appState.registred {
            load(.entries)
        } else {
            load(.registration)
        }
    }

    func load(_ route: Route) {
        logger.info("Load route \(route.id)")
        self.route = route
        currentView = PresentedView(id: route.id, wrappedView: route.view)
    }
}
