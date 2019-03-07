//
//  PaidSubscription.swift
//  wallabag
//
//  Created by maxime marinel on 10/08/2018.
//

import Foundation

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"

    return formatter
}()

public struct PaidSubscription {
    public let productId: String
    public let purchaseDate: Date
    public let expiresDate: Date

    public var isActive: Bool {
        // is current date between purchaseDate and expiresDate?
        return (purchaseDate ... expiresDate).contains(Date())
    }

    init?(json: [String: Any]) {
        guard
            let productId = json["product_id"] as? String,
            let purchaseDateString = json["purchase_date"] as? String,
            let purchaseDate = dateFormatter.date(from: purchaseDateString),
            let expiresDateString = json["expires_date"] as? String,
            let expiresDate = dateFormatter.date(from: expiresDateString)
        else {
            return nil
        }

        self.productId = productId
        self.purchaseDate = purchaseDate
        self.expiresDate = expiresDate
    }
}
