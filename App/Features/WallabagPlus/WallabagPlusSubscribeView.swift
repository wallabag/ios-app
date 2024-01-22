//
//  WallabagPlusSubscribeView.swift
//  wallabag
//
//  Created by maxime marinel on 11/01/2024.
//

import StoreKit
import SwiftUI

struct WallabagPlusSubscribeView: View {
    @BundleKey("PRIVACY_URL")
    private var privacyURL

    @BundleKey("TERMS_OF_USE_URL")
    private var termsOfUseURL

    @EnvironmentObject var wallabagPlusStore: WallabagPlusStore

    var body: some View {
        SubscriptionStoreView(groupID: wallabagPlusStore.groupID, visibleRelationships: .all)
            .subscriptionStoreButtonLabel(.multiline)
            .storeButton(.visible, for: .restorePurchases)
            .subscriptionStorePolicyDestination(url: privacyURL.url!, for: .privacyPolicy)
            .subscriptionStorePolicyDestination(url: termsOfUseURL.url!, for: .termsOfService)
            .subscriptionStoreControlStyle(.prominentPicker)
            .onInAppPurchaseCompletion { _, result in
                if case let .success(.success(transaction)) = result {
                    Task {
                        await wallabagPlusStore.finish(transaction)
                    }
                }
            }
    }
}

#Preview {
    WallabagPlusSubscribeView()
}
