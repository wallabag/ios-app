//
//  WallabagPlusSubscribeView.swift
//  wallabag
//
//  Created by maxime marinel on 11/01/2024.
//

import RevenueCat
import RevenueCatUI
import SwiftUI

struct WallabagPlusSubscribeView: View {
    @BundleKey("PRIVACY_URL")
    private var privacyURL

    @BundleKey("TERMS_OF_USE_URL")
    private var termsOfUseURL

    @Environment(WallabagPlusStore.self) var wallabagPlusStore

    var body: some View {
        Text("")
            .presentPaywallIfNeeded(requiredEntitlementIdentifier: "pro")
    }
}

#Preview {
    WallabagPlusSubscribeView()
}
