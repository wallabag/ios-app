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

enum Route: Equatable {
    case tips
    case about
    case entries
    case entry(Entry)
    case addEntry
    case registration
    case bugReport

    var title: String {
        switch self {
        case .addEntry:
            return "Add entry"
        case .entries:
            return "Articles"
        case .entry:
            return "Article"
        case .tips:
            return "Tips"
        case .about:
            return "About"
        case .registration:
            return "Registration"
        case .bugReport:
            return "Bug report"
        }
    }

    var showMenuButton: Bool {
        self != .registration
    }

    var showHeader: Bool {
        switch self {
        case .entry, .registration:
            return false
        default:
            return true
        }
    }

    var showTraillingButton: Bool {
        self == .entries
    }

    var traillingButton: AnyView? {
        switch self {
        case .entries:
            return AnyView(RefreshButton())
        default:
            return nil
        }
    }
}

class Router: ObservableObject {
    @Injector var appState: AppState
    @Injector var logger: Logger

    var objectWillChange = PassthroughSubject<Router, Never>()

    init() {
        route = appState.registred ? .entries : .registration
    }

    var route: Route = .entries {
        willSet {
            logger.info("Router switch to route: \(newValue.title)")
            objectWillChange.send(self)
        }
    }
}
