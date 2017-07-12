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
                log.info("Transaction completed successfully.")
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                tipButton.titleLabel?.text = "Thank you!!!"
            case .failed:
                log.error("Transaction error")
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
            case .deferred:
                log.debug("Transaction deferred")
            case .purchasing:
                log.debug("Transaction purchasing")
            case .restored:
                log.debug("Transaction restored")
            }
        }
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        log.debug("Request product")
        if response.products.count != 0 {
            if let _product = response.products.first {
                product = _product
            }
        } else {
            log.error("There are no products.")
            log.debug(response.invalidProductIdentifiers.description)
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
            log.debug("Can make paiement")
            let productRequest  = SKProductsRequest(productIdentifiers: productIDs)
            productRequest.delegate = self
            productRequest.start()
        } else {
            log.error("Cannot perfom In App Purchases")
        }
    }
}
