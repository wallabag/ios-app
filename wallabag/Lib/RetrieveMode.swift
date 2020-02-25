//
//  RetrieveMode.swift
//  wallabag
//
//  Created by maxime marinel on 04/09/2018.
//

import Foundation

enum RetrieveMode: String, CaseIterable {
    case allArticles = "All"
    case archivedArticles = "Read"
    case unarchivedArticles = "Unread"
    case starredArticles = "Starred"

    init(fromCase: String) {
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
            fatalError()
        }
    }

    func predicate() -> NSPredicate {
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
