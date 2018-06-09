//
//  WallabagKitEntry.swift
//  wallabag
//
//  Created by maxime marinel on 09/06/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation

struct WallabagKitEntry: Codable {
    let id: Int
    let userId: Int?
    let uid: String?
    let title: String?
    let url: String?
    let isArchived: Int
    let isStarred: Int
    let content: String?
    let createdAt: String
    let updatedAt: String
    let mimetype: String?
    let language: String?
    let readingTime: Int?
    let domainName: String?
    let previewPicture: String?
    //    let isPublic: Int

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case uid
        case title
        case url
        case isArchived = "is_archived"
        case isStarred = "is_starred"
        case content
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case mimetype
        case language
        case readingTime = "reading_time"
        case domainName = "domain_name"
        case previewPicture = "preview_picture"
        //        case isPublic = "is_public"
    }
}
