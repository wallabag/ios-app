//
//  Int.swift
//  wallabag
//
//  Created by maxime marinel on 30/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import Foundation

extension Int {
    var readingTime: String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(self * 60))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "mm:ss"

        return dayTimePeriodFormatter.string(from: date as Date)
    }

    var rgb: CGFloat {
        return CGFloat(self) / 255.0
    }
}
