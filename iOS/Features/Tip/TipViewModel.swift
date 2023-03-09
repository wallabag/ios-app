import Foundation
import StoreKit

final class TipViewModel: ObservableObject {
    @Published var canMakePayments: Bool = false
    @Published var tipProduct: Product?
    @Published var paymentSuccess = false

    var taskHandle: Task<Void, Error>?

    init() {
        canMakePayments = SKPaymentQueue.canMakePayments()
        if canMakePayments {
            Task { @MainActor in
                let product = try? await requestProduct()
                tipProduct = product?.first
            }
        }

        taskHandle = listenForTransactions()
    }

    private func requestProduct() async throws -> [Product] {
        try await Product.products(for: ["tips1"])
    }

    func listenForTransactions() -> Task<Void, Error> {
        Task {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await transaction.finish()
                } catch {
                    print("Transaction failed verification")
                }
            }
        }
    }

    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case let .verified(safe):
            return safe
        }
    }

    func purchaseTip() async throws -> StoreKit.Transaction? {
        guard let product = tipProduct else { return nil }

        let result = try await product.purchase()

        switch result {
        case let .success(verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            paymentSuccess = true
            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
}

public enum StoreError: Error {
    case failedVerification
}
