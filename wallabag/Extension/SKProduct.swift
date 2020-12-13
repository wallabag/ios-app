import Foundation
import StoreKit

extension SKProduct {
    var title: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale

        return "\(localizedTitle) \(formatter.string(from: price)!)"
    }
}
