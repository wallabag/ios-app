//
//  Article.swift
//  wallabag
//
//  Created by maxime marinel on 22/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import Foundation

struct Article {

    lazy var html: String = {
        return try! String(contentsOfFile: Bundle.main.path(forResource: "article", ofType: "html")!)
    }()

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
        created_at = (fromDictionary["created_at"] as! String).date ?? Date()
        domain_name = fromDictionary["domain_name"] as? String ?? ""
        id = fromDictionary["id"] as! Int
        is_archived = fromDictionary["is_archived"] as! Bool
        is_starred = fromDictionary["is_starred"] as! Bool
        language = fromDictionary["language"] as? String ?? ""
        mimetype = fromDictionary["mimetype"] as? String ?? ""
        preview_picture = fromDictionary["preview_picture"] as? String
        reading_time = fromDictionary["reading_time"] as? Int ?? 1

        var tagsStack: Set<Tag> = Set()
        for tag in (fromDictionary["tags"] as? [[String: Any]])! {
            tagsStack.insert(Tag(fromDictionary: tag))
        }
        tags = tagsStack

        title = fromDictionary["title"] as? String ?? ""
        updated_at = (fromDictionary["updated_at"] as! String).date ?? Date()
        url = fromDictionary["url"] as? String ?? ""
        user_email = fromDictionary["user_email"] as! String
        user_id = fromDictionary["user_id"] as! Int
        user_name = fromDictionary["user_name"] as! String
    }

    mutating func contentForWebView() -> String {
        return String(format: html, arguments: [title, content])
    }
}
