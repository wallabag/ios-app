import Foundation
import StoreKit
import SwiftUI

class TipViewModel: NSObject, ObservableObject {
    @Published var canMakePayments: Bool = false

    @Published var transactionSuccess: Bool = false
    @Published var tipProduct: Product?

    var transactionInProgress: Bool = false

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)

        canMakePayments = SKPaymentQueue.canMakePayments()
        if canMakePayments {
            Task {
                let product = try? await requestProduct()
                tipProduct = product?.first
            }
        }
    }

    private func requestProduct() async throws -> [Product] {
        return try await Product.products(for: ["tips1"])
        let productRequest = SKProductsRequest(productIdentifiers: ["tips1"])
        productRequest.delegate = self
        productRequest.start()
    }

    func purchaseTip() {
        guard let product = tipProduct else { return }

        Task {
            let result = try await product.purchase()
        }

        /*let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)*/
        transactionInProgress = true
    }
}

extension TipViewModel: SKProductsRequestDelegate {
    func productsRequest(_: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            response.products.first.map { product in
                DispatchQueue.main.async { [weak self] in
                    withAnimation {
                        //self?.tipProduct = product
                    }
                }
            }
        }
    }
}

extension TipViewModel: SKPaymentTransactionObserver {
    func paymentQueue(_: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        defer {
            transactionInProgress = false
        }

        transactions.forEach { transaction in
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                self.transactionSuccess = true
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)

            default:
                break
            }
        }
    }
}
