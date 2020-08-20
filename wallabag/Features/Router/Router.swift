//
//  Router.swift
//  wallabag
//
//  Created by Marinel Maxime on 10/02/2020.
//

import Combine
import Foundation
import Logging
import SwiftUI

final class Router: ObservableObject {
    @Injector private var appState: AppState
    @Injector private var logger: Logger

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
