//
//  Date.swift
//  wallabag
//
//  Created by maxime marinel on 10/04/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation

extension Date {
    static func fromISOString(_ string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssX"
        return dateFormatter.date(from: string)
    }
}
