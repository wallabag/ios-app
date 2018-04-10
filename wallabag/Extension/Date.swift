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
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        return dateFormatter.date(from: string)
    }
}
