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
    case about
    case addEntry
    case bugReport
    case entries
    case entry(Entry)
    case registration
    case tips

    var id: String {
        switch self {
        case .about:
            return "about"
        case .addEntry:
            return "addEntry"
        case .bugReport:
            return "bugReport"
        case .entries:
            return "entries"
        case .entry:
            return "entry"
        case .registration:
            return "registration"
        case .tips:
            return "tips"
        }
    }

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

    var view: AnyView {
        switch self {
        case .about:
            return AnyView(AboutView())
        case .addEntry:
            return AnyView(AddEntryView())
        case .bugReport:
            return AnyView(BugReportView())
        case .entries:
            return AnyView(EntriesView())
        case let .entry(entry):
            return AnyView(EntryView(entry: entry))
        case .registration:
            return AnyView(RegistrationView())
        case .tips:
            return AnyView(TipView())
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

struct PresentedView: Identifiable {
    let id: String
    let wrappedView: AnyView
}
