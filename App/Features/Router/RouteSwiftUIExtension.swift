//
//  RouteSwiftUIExtension.swift
//  wallabag (iOS)
//
//  Created by maxime marinel on 13/03/2023.
//

import Foundation
import SwiftUI

extension View {
    func appRouting() -> some View {
        navigationDestination(for: RoutePath.self) { route in
            switch route {
            case .addEntry:
                AddEntryView()
            case let .entry(entry):
                EntryView(entry: entry)
            case let .synthesis(entry):
                SynthesisEntryView(entry: entry)
                    .wallabagPlusProtected()
            case let .tags(entry):
                TagSuggestionView(entry: entry)
                    .wallabagPlusProtected()
            case .about:
                AboutView()
            case .tips:
                TipView()
            case .setting:
                SettingView()
            case .registration:
                RegistrationView()
            }
        }
    }
}
