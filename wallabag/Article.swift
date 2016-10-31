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
    let tags: [Tag]
    let title: String
    let updated_at: Date
    let url: String
    let user_email: String
    let user_id: Int
    let user_name: String

    init(fromItem: [String: Any]) {
        annotations = []
        content = fromItem["content"] as! String
        created_at = (fromItem["created_at"] as! String).date ?? Date()
        domain_name = fromItem["domain_name"] as! String
        id = fromItem["id"] as! Int
        is_archived = fromItem["is_archived"] as! Bool
        is_starred = fromItem["is_starred"] as! Bool
        language = fromItem["language"] as? String ?? ""
        mimetype = fromItem["mimetype"] as! String
        preview_picture = fromItem["preview_picture"] as? String
        reading_time = fromItem["reading_time"] as! Int

        var tagsStack = [Tag]()
        for tag in (fromItem["tags"] as? [[String: Any]])! {
            tagsStack.append(Tag(id: tag["id"] as! Int, label: tag["label"] as! String, slug: tag["slug"] as! String))
        }
        tags = tagsStack

        title = fromItem["title"] as! String
        updated_at = (fromItem["updated_at"] as! String).date ?? Date()
        url = fromItem["url"] as? String ?? ""
        user_email = fromItem["user_email"] as! String
        user_id = fromItem["user_id"] as! Int
        user_name = fromItem["user_name"] as! String
    }
}
