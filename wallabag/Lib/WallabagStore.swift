//
//  WallabagStore.swift
//  wallabag
//
//  Created by maxime marinel on 10/08/2018.
//

import Foundation
import StoreKit

public enum Result<T> {
    case failure(Error)
    case success(T)
}

public typealias UploadReceiptCompletion = (_ result: Result<(sessionId: String, currentSubscription: PaidSubscription?)>) -> Void

final class WallabagStore: NSObject {
    static let sessionIdSetNotification = Notification.Name("SubscriptionServiceSessionIdSetNotification")
    static let optionsLoadedNotification = Notification.Name("SubscriptionServiceOptionsLoadedNotification")
    static let restoreSuccessfulNotification = Notification.Name("SubscriptionServiceRestoreSuccessfulNotification")
    static let purchaseSuccessfulNotification = Notification.Name("SubscriptionServiceRestoreSuccessfulNotification")

    static let shared = WallabagStore()
    
    var hasReceiptData: Bool {
        uploadReceipt()
        return loadReceipt() != nil
    }

    var currentSessionId: String? {
        didSet {
            NotificationCenter.default.post(name: WallabagStore.sessionIdSetNotification, object: currentSessionId)
        }
    }

    var currentSubscription: PaidSubscription?

    var options: [WallabagSubscription]? {
        didSet {
            NotificationCenter.default.post(name: WallabagStore.optionsLoadedNotification, object: options)
        }
    }

    func loadSubscriptionOptions() {

        let productIDPrefix = Bundle.main.bundleIdentifier! + ".sub."

        let allAccess = productIDPrefix + "allaccess"
        let oneAWeek  = productIDPrefix + "oneaweek"

        let allAccessMonthly = productIDPrefix + "allaccess.monthly"
        let oneAWeekMonthly  = productIDPrefix + "oneaweek.monthly"

        let productIDs = Set([allAccess, oneAWeek, allAccessMonthly, oneAWeekMonthly])

        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
    }

    func purchase(subscription: WallabagSubscription) {
        let payment = SKPayment(product: subscription.product)
        SKPaymentQueue.default().add(payment)
    }

    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    func uploadReceipt(completion: ((_ success: Bool) -> Void)? = nil) {
        if let receiptData = loadReceipt() {
            upload(receipt: receiptData) { [weak self] (result) in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let result):
                    strongSelf.currentSessionId = result.sessionId
                    strongSelf.currentSubscription = result.currentSubscription
                    completion?(true)
                case .failure(let error):
                    print("🚫 Receipt Upload Failed: \(error)")
                    completion?(false)
                }
            }
        }
    }

    private func upload(receipt data: Data, completion: @escaping UploadReceiptCompletion) {
        let body = [
            "receipt-data": data.base64EncodedString(),
            "password": "65bdeeb88cfb488d8f4d5a4786afa936"
        ]
        let bodyData = try! JSONSerialization.data(withJSONObject: body, options: [])

        let url = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData

        let task = URLSession.shared.dataTask(with: request) { (responseData, response, error) in
            if let error = error {
                print(error)
                //completion(.failure(.other(error)))
            } else if let responseData = responseData {
                let json = try! JSONSerialization.jsonObject(with: responseData, options: []) as! Dictionary<String, Any>
                if let receipt = json["receipt"] as? [String: Any], let purchases = receipt["in_app"] as? Array<[String: Any]> {
                    var subscriptions = [PaidSubscription]()
                    for purchase in purchases {
                        if let paidSubscription = PaidSubscription(json: purchase) {
                            subscriptions.append(paidSubscription)
                        }
                    }

                    //currentSubscription = subscriptions.filter { $0.isActive }.first
                    //paidSubscriptions = subscriptions
                } else {
                    //paidSubscriptions = []
                }



                //let session = Session(receiptData: data, parsedReceipt: json)
                //self.sessions[session.id] = session
                //let result = (sessionId: session.id, currentSubscription: session.currentSubscription)
                //completion(.success(result))
            }
        }

        task.resume()
    }

    private func loadReceipt() -> Data? {
        guard let url = Bundle.main.appStoreReceiptURL else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("Error loading receipt data: \(error.localizedDescription)")
            return nil
        }
    }
}

// MARK: - SKProductsRequestDelegate
extension WallabagStore: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        options = response.products.map { WallabagSubscription(product: $0) }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        if request is SKProductsRequest {
            print("Subscription Options Failed Loading: \(error.localizedDescription)")
        }
    }
}
