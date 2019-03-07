//
//  SubscriptionViewController.swift
//  wallabag
//
//  Created by maxime marinel on 10/08/2018.
//

import StoreKit
import UIKit

class SubscriptionViewController: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    var productIDs: Set<String> = ["podcast"]
    var product: SKProduct!
    var transactionInProgress = false {
        didSet {
            subscribeButton.isEnabled = !transactionInProgress
        }
    }

    @IBOutlet var subscribeButton: UIButton!

    @IBAction func subscribe(_: UIButton) {
        if transactionInProgress {
            return
        }

        let payment = SKPayment(product: product!)
        SKPaymentQueue.default().add(payment)
        transactionInProgress = true
    }

    func paymentQueue(_: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                Log("Transaction completed successfully.")
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
            //tipButton.titleLabel?.text = "Thank you!!!"
            // analytics.send(.tipPurchased)
            case .failed:
                Log("Transaction error")
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
            case .deferred:
                Log("Transaction deferred")
            case .purchasing:
                Log("Transaction purchasing")
            case .restored:
                Log("Transaction restored")
            }
        }
    }

    func productsRequest(_: SKProductsRequest, didReceive response: SKProductsResponse) {
        Log("Request product")
        if response.products.count != 0,
            let firstproduct = response.products.first {
            product = firstproduct
            subscribeButton.isEnabled = true
            Log("Product found")
        } else {
            Log("There are no products.")
            Log(response.invalidProductIdentifiers.description)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeButton.isEnabled = false

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }

        SKPaymentQueue.default().add(self)

        let productRequest = SKProductsRequest(productIdentifiers: productIDs)
        productRequest.delegate = self
        productRequest.start()
    }
}
