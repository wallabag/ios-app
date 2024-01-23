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
            "allArticles"
        case .archivedArticles:
            "archivedArticles"
        case .unarchivedArticles:
            "unarchivedArticles"
        case .starredArticles:
            "starredArticles"
        }
    }

    public func predicate() -> NSPredicate {
        switch self {
        case .unarchivedArticles:
            NSPredicate(format: "isArchived == NO")
        case .starredArticles:
            NSPredicate(format: "isStarred == YES")
        case .archivedArticles:
            NSPredicate(format: "isArchived == YES")
        case .allArticles:
            NSPredicate(value: true)
        }
    }
}
