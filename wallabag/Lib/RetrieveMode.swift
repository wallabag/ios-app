//
//  RetrieveMode.swift
//  wallabag
//
//  Created by maxime marinel on 04/09/2018.
//

import Foundation

enum RetrieveMode: String {
    case allArticles
    case archivedArticles
    case unarchivedArticles
    case starredArticles

    func humainReadable() -> String {
        switch self {
        case .allArticles:
            return "All articles"
        case .archivedArticles:
            return "Read articles"
        case .starredArticles:
            return "Starred articles"
        case .unarchivedArticles:
            return "Unread articles"
        }
    }

    func predicate() -> NSPredicate {
        switch self {
        case .unarchivedArticles:
            return NSPredicate(format: "isArchived == 0")
        case .starredArticles:
            return NSPredicate(format: "isStarred == 1")
        case .archivedArticles:
            return NSPredicate(format: "isArchived == 1")
        case .allArticles:
            return NSPredicate(value: true)
        }
    }
}
