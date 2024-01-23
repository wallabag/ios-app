//
//  WallabagPlusStore.swift
//  wallabag
//
//  Created by maxime marinel on 11/01/2024.
//

import Foundation
import StoreKit

final class WallabagPlusStore: ObservableObject {
    private var obs: Task<Void, Never>?

    let groupID = "21433277"

    @Published var proUnlocked = false

    init() {
        obs = observeTransactionUpdates()
        restorePurchase()
    }

    deinit {
        obs?.cancel()
    }

    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
            for await verification in Transaction.updates {
                await finish(verification)
            }
        }
    }

    func restorePurchase() {
        Task {
            if let result = await Transaction.latest(for: "wallabagplus") {
                await finish(result)
            }
        }
    }

    @MainActor
    func finish(_ result: VerificationResult<Transaction>) async {
        switch result {
        case .unverified:
            proUnlocked = false
        case let .verified(signedType):
            await signedType.finish()
            let status = await signedType.subscriptionStatus
            proUnlocked = status?.state == .subscribed
        }
    }

    func handleStatues(_ statuses: [Product.SubscriptionInfo.Status]) async {
        guard let transtaction = statuses.last?.transaction else { return }

        await finish(transtaction)
    }
}
