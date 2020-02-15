//
//  SKPublisher.swift
//  wallabag
//
//  Created by Marinel Maxime on 12/02/2020.
//

import Foundation
import StoreKit

class SKPublisher: NSObject, ObservableObject {
    @Published var canMakePayments: Bool = false {
        didSet {
            if canMakePayments {
                requestProduct()
            }
        }
    }

    @Published var transactionSuccess: Bool = false
    @Published var tipProduct: SKProduct?

    var transactionInProgress: Bool = false

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)

        canMakePayments = SKPaymentQueue.canMakePayments()
    }

    private func requestProduct() {
        let productRequest = SKProductsRequest(productIdentifiers: ["tips1"])
        productRequest.delegate = self
        productRequest.start()
    }

    func purchaseTip() {
        guard let product = tipProduct else { return }

        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        transactionInProgress = true
    }
}

extension SKPublisher: SKProductsRequestDelegate {
    func productsRequest(_: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            response.products.first.map { product in
                DispatchQueue.main.async { [unowned self] in
                    self.tipProduct = product
                }
            }
        }
    }
}

extension SKPublisher: SKPaymentTransactionObserver {
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
