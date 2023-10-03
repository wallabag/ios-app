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
            case .about:
                AboutView()
            case .tips:
                TipView()
            case .setting:
                SettingView()
            default:
                Text("test")
            }
        }
    }
}
