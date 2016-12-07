//
//  Int.swift
//  wallabag
//
//  Created by maxime marinel on 30/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

extension Int {
    var readingTime: String {
        get {
            let date = NSDate(timeIntervalSince1970: TimeInterval(self * 60))
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "mm:ss"

            let dateString = dayTimePeriodFormatter.string(from: date as Date)

            return dateString
        }
    }
    
    var rgb: CGFloat{
        return CGFloat(self) / 255.0
    }
}
