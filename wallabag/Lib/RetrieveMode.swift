//
//  RetrieveMode.swift
//  wallabag
//
//  Created by maxime marinel on 04/09/2018.
//

import Foundation

enum RetrieveMode: String, CaseIterable {
    case allArticles = "All articles"
    case archivedArticles = "Read articles"
    case unarchivedArticles = "Unread articles"
    case starredArticles = "Starred articles"

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
