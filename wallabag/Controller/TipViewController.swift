//
//  TipViewController.swift
//  wallabag
//
//  Created by maxime marinel on 10/06/2017.
//  Copyright © 2017 maxime marinel. All rights reserved.
//

import UIKit
import StoreKit

final class TipViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    let analytics = AnalyticsManager()
    var transactionInProgress = false
    var productIDs: Set<String> = ["tips1"]
    var product: SKProduct? {
        didSet {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = product!.priceLocale
            tipButton.setTitle("\(product!.localizedTitle) \(formatter.string(from: product!.price)!)", for: .normal)
        }
    }

    @IBOutlet weak var tipContent: UITextView!
    @IBOutlet weak var tipButton: UIButton!
    @IBAction func tip(_ sender: Any) {
        if transactionInProgress {
            return
        }

        let payment = SKPayment(product: product!)
        SKPaymentQueue.default().add(payment)
        self.transactionInProgress = true
        analytics.send(.tip)
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                Log("Transaction completed successfully.")
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                tipButton.titleLabel?.text = "Thank you!!!"
                analytics.send(.tipPurchased)
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

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        Log("Request product")
        if response.products.count != 0,
            let firstproduct = response.products.first {
                product = firstproduct
                tipButton.isEnabled = true
        } else {
            Log("There are no products.")
            Log(response.invalidProductIdentifiers.description)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        analytics.sendScreenViewed(.tipView)

        view.backgroundColor = ThemeManager.manager.getBackgroundColor()
        tipContent.text = "This application is developed on free time, it is free and will remain so. But you can contribute financially by making a donation whenever you want to support the project.".localized
        tipContent.textColor = ThemeManager.manager.getColor()

        SKPaymentQueue.default().add(self)
        tipButton.isEnabled = false
        requestProductInfo()
    }

    private func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            Log("Can make paiement")
            let productRequest  = SKProductsRequest(productIdentifiers: productIDs)
            productRequest.delegate = self
            productRequest.start()
        } else {
            Log("Cannot perfom In App Purchases")
        }
    }
}
