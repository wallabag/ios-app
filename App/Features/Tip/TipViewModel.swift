import Foundation
import Observation
import RevenueCat

@Observable
final class TipViewModel {
    @ObservationIgnored @BundleKey("REVENUECAT_KEY")
    private var revenueCatKey: String

    var canMakePayments: Bool = false
    var tipProduct: StoreProduct?
    var paymentSuccess = false

    init() {
        canMakePayments = Purchases.canMakePayments()
        Purchases.configure(withAPIKey: revenueCatKey)
    }

    func loadProduct() async {
        guard canMakePayments else { return }
        tipProduct = await Purchases.shared.products(["tips1"]).first
    }

    func purchaseTip() async throws {
        guard let product = tipProduct else { return }

        let result = try await Purchases.shared.purchase(product: product)

        paymentSuccess = !result.userCancelled
    }
}

public enum StoreError: Error {
    case failedVerification
}
