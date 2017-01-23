//
//  Article.swift
//  wallabag
//
//  Created by maxime marinel on 22/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import Foundation

struct Article {

    let id: Int
    let annotations: Set<String>
    let content: String
    let createdAt: Date
    let domainName: String
    let isArchived: Bool
    let isStarred: Bool
    let language: String
    let mimetype: String
    let previewPicture: String?
    let readingTime: Int
    let tags: Set<Tag>
    let title: String
    let updatedAt: Date
    let url: String
    let userEmail: String
    let userId: Int
    let userName: String

    init(fromDictionary: [String: Any]) {

        //@todo Failable ?
        id = fromDictionary["id"] as? Int ?? 0

        annotations = []
        content = fromDictionary["content"] as? String ?? ""
        createdAt = (fromDictionary["created_at"] as? String)?.date ?? Date()
        updatedAt = (fromDictionary["updated_at"] as? String)?.date ?? Date()
        domainName = fromDictionary["domain_name"] as? String ?? ""
        isArchived = (fromDictionary["is_archived"] as? Bool) ?? false
        isStarred = (fromDictionary["is_starred"] as? Bool) ?? false
        language = fromDictionary["language"] as? String ?? ""
        mimetype = fromDictionary["mimetype"] as? String ?? ""
        previewPicture = fromDictionary["preview_picture"] as? String
        readingTime = fromDictionary["reading_time"] as? Int ?? 1

        var tagsStack: Set<Tag> = Set()
        if let tags = fromDictionary["tags"] as? [[String: Any]] {
            for tag in tags {
                tagsStack.insert(Tag(fromDictionary: tag))
            }
        }
        self.tags = tagsStack

        title = fromDictionary["title"] as? String ?? ""
        url = fromDictionary["url"] as? String ?? ""
        userEmail = fromDictionary["user_email"] as? String ?? ""
        userId = fromDictionary["user_id"] as? Int ?? 0
        userName = fromDictionary["user_name"] as? String ?? ""
    }
}
