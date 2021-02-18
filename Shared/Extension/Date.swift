import Foundation

extension Date {
    static func fromISOString(_ string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssX"
        return dateFormatter.date(from: string)
    }
}
