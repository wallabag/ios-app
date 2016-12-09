//
//  Article.swift
//  wallabag
//
//  Created by maxime marinel on 22/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import Foundation

struct Article {

    let annotations: Set<String>
    let content: String
    let created_at: Date
    let domain_name: String
    let id: Int
    let is_archived: Bool
    let is_starred: Bool
    let language: String
    let mimetype: String
    let preview_picture: String?
    let reading_time: Int
    let tags: Set<Tag>
    let title: String
    let updated_at: Date
    let url: String
    let user_email: String
    let user_id: Int
    let user_name: String

    init(fromDictionary: [String: Any]) {
        annotations = []
        content = fromDictionary["content"] as? String ?? ""
        created_at = (fromDictionary["created_at"] as? String) != nil ? (fromDictionary["created_at"] as! String).date ?? Date() : Date()
        domain_name = fromDictionary["domain_name"] as? String ?? ""
        id = fromDictionary["id"] as! Int
        is_archived = (fromDictionary["is_archived"] as? Bool) ?? false
        is_starred = (fromDictionary["is_starred"] as? Bool) ?? false
        language = fromDictionary["language"] as? String ?? ""
        mimetype = fromDictionary["mimetype"] as? String ?? ""
        preview_picture = fromDictionary["preview_picture"] as? String
        reading_time = fromDictionary["reading_time"] as? Int ?? 1

        var tagsStack: Set<Tag> = Set()
        if let tags = fromDictionary["tags"] as? [[String: Any]] {
            for tag in tags {
                tagsStack.insert(Tag(fromDictionary: tag))
            }
        }
        self.tags = tagsStack

        title = fromDictionary["title"] as? String ?? ""
        updated_at = (fromDictionary["updated_at"] as? String) != nil ? (fromDictionary["updated_at"] as! String).date ?? Date() : Date()
        url = fromDictionary["url"] as? String ?? ""
        user_email = fromDictionary["user_email"] as? String ?? ""
        user_id = fromDictionary["user_id"] as? Int ?? 0
        user_name = fromDictionary["user_name"] as? String ?? ""
    }
}
