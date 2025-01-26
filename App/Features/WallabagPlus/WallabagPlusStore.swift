import Foundation
import Observation
import RevenueCat

@Observable
final class WallabagPlusStore {
    @ObservationIgnored @BundleKey("REVENUECAT_KEY")
    private var revenueCatKey: String

    var proUnlocked = false

    init() {
        Purchases.configure(withAPIKey: revenueCatKey)
    }

    func checkPro() async {
        proUnlocked = await (try? Purchases.shared.customerInfo(fetchPolicy: .fetchCurrent).entitlements.active.keys.contains("pro")) ?? false
    }
}
