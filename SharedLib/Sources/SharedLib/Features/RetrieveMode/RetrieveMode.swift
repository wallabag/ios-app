import Foundation

public enum RetrieveMode: String, CaseIterable {
    case allArticles = "All"
    case archivedArticles = "Read"
    case unarchivedArticles = "Unread"
    case starredArticles = "Starred"

    public init(fromCase: String) {
        switch fromCase {
        case "allArticles":
            self = .allArticles
        case "archivedArticles":
            self = .archivedArticles
        case "unarchivedArticles":
            self = .unarchivedArticles
        case "starredArticles":
            self = .starredArticles
        default:
            self = .allArticles
        }
    }

    public var settingCase: String {
        switch self {
        case .allArticles:
            return "allArticles"
        case .archivedArticles:
            return "archivedArticles"
        case .unarchivedArticles:
            return "unarchivedArticles"
        case .starredArticles:
            return "starredArticles"
        }
    }

    public func predicate() -> NSPredicate {
        switch self {
        case .unarchivedArticles:
            return NSPredicate(format: "isArchived == NO")
        case .starredArticles:
            return NSPredicate(format: "isStarred == YES")
        case .archivedArticles:
            return NSPredicate(format: "isArchived == YES")
        case .allArticles:
            return NSPredicate(value: true)
        }
    }
}
