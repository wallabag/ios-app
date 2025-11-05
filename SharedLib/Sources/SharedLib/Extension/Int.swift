import Foundation

public extension Int {
    var readingTime: String {
        let totalSeconds = self * 60
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    var bool: Bool {
        self == 1
    }
}
