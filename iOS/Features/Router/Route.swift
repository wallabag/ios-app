import Foundation
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

    var title: LocalizedStringKey {
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

    @ViewBuilder
    var view: some View {
        switch self {
        case .about:
            AboutView()
        case .addEntry:
            AddEntryView()
        case .bugReport:
            BugReportView()
        case .entries:
            EntriesView()
        case let .entry(entry):
            EntryView(entry: entry)
        case .registration:
            RegistrationView()
        case .tips:
            TipView()
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

    var traillingButton: some View {
        switch self {
        case .entries:
            return RefreshButton()
        default:
            fatalError("call trailling button")
        }
    }
}
