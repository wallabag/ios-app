import Foundation
import Observation
import RevenueCat

@Observable
final class WallabagPlusStore {
    private let userDefaultKey = "REVENUECAT_SYNCED"
    @ObservationIgnored @BundleKey("REVENUECAT_KEY")
    private var revenueCatKey: String

    var proUnlocked = false

    init() {
        Purchases.configure(withAPIKey: revenueCatKey)
    }

    func checkPro() async {
        if !UserDefaults.standard.bool(forKey: userDefaultKey) {
            _ = try? await Purchases.shared.syncPurchases()
            UserDefaults.standard.set(true, forKey: userDefaultKey)
        }
        proUnlocked = await (try? Purchases.shared.customerInfo(fetchPolicy: .fetchCurrent).entitlements.active.keys.contains("pro")) ?? false
    }
}
