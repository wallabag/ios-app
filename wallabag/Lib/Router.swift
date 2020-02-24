//
//  Router.swift
//  wallabag
//
//  Created by Marinel Maxime on 10/02/2020.
//

import Combine
import Foundation
import SwiftUI

enum Route: Equatable {
    case none
    case tips
    case about
    case entries
    case entry(Entry)
    case addEntry
    case registration

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
        default:
            return "Test"
        }
    }

    var showMenuButton: Bool {
        self != .registration
    }

    var showHeader: Bool {
        switch self {
        case .entry:
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
            return AnyView(RefreshButton(appSync: AppSync()))
        default:
            return nil
        }
    }
}

class Router: ObservableObject {
    @Injector var appState: AppState

    var objectWillChange = PassthroughSubject<Router, Never>()

    init() {
        route = appState.registred ? .entries : .registration
    }

    var route: Route = .entries {
        willSet {
            appState.showMenu = false
            objectWillChange.send(self)
        }
    }
}
