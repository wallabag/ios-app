import Foundation

public extension Bundle {
    class func infoForKey(_ key: String) -> String? {
        (Bundle.main.infoDictionary?[key] as? String)?
            .replacingOccurrences(of: "\\", with: "")
    }

    class func boolForKey(_ key: String) -> Bool {
        guard let str = infoForKey(key) else { return false }

        return str == "YES" ? true : false
    }
}
