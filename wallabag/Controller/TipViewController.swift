//
//  TipViewController.swift
//  wallabag
//
//  Created by maxime marinel on 10/06/2017.
//  Copyright © 2017 maxime marinel. All rights reserved.
//

import UIKit
import StoreKit

class TipViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
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
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                NSLog("Transaction completed successfully.")
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                tipButton.titleLabel?.text = "Thank you!!!"
            case .failed:
                NSLog("Transaction error")
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
            case .deferred:
                NSLog("Transaction deferred")
            case .purchasing:
                NSLog("Transaction purchasing")
            case .restored:
                NSLog("Transaction restored")
            }
        }
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        NSLog("Request product")
        if response.products.count != 0 {
            if let _product = response.products.first {
                product = _product
            }
        } else {
            NSLog("There are no products.")
            NSLog(response.invalidProductIdentifiers.description)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ThemeManager.manager.getBackgroundColor()
        tipContent.text = "This application is developed on free time, it is free and will remain so. But you can contribute financially by making a donation whenever you want to support the project.".localized
        tipContent.textColor = ThemeManager.manager.getColor()

        SKPaymentQueue.default().add(self)
        requestProductInfo()
    }

    private func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            NSLog("Can make paiement")
            let productRequest  = SKProductsRequest(productIdentifiers: productIDs)
            productRequest.delegate = self
            productRequest.start()
        } else {
            NSLog("Cannot perfom In App Purchases")
        }
    }
}
