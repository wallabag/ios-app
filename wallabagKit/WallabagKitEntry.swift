//
//  WallabagKitEntry.swift
//  wallabag
//
//  Created by maxime marinel on 09/06/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation

public struct WallabagKitEntry: Codable {
    public let id: Int
    public let userId: Int?
    public let uid: String?
    public let title: String?
    public let url: String?
    public let isArchived: Int
    public let isStarred: Int
    public let content: String?
    public let createdAt: String
    public let updatedAt: String
    public let mimetype: String?
    public let language: String?
    public let readingTime: Int?
    public let domainName: String?
    public let previewPicture: String?
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
