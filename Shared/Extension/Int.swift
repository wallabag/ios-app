import Foundation
import UIKit

extension Int {
    var readingTime: String {
        let date = Date(timeIntervalSince1970: TimeInterval(self * 60))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dayTimePeriodFormatter.dateFormat = "HH:mm:ss"

        return dayTimePeriodFormatter.string(from: date as Date)
    }

    var rgb: CGFloat {
        CGFloat(self) / 255.0
    }

    var bool: Bool {
        self == 1
    }
}
