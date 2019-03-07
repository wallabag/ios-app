//
//  Entry.swift
//  wallabag
//
//  Created by maxime marinel on 27/02/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation
import RealmSwift
import WallabagKit

final class Entry: Object {
    @objc public dynamic var content: String?
    @objc public dynamic var createdAt: Date?
    @objc public dynamic var domainName: String?
    @objc public dynamic var id: Int = 0
    @objc public dynamic var isArchived: Bool = false
    @objc public dynamic var isStarred: Bool = false
    @objc public dynamic var previewPicture: String?
    @objc public dynamic var title: String?
    @objc public dynamic var updatedAt: Date?
    @objc public dynamic var url: String?
    @objc public dynamic var readingTime: Int = 0
    @objc public dynamic var screenPosition: Float = 0.0

    override class func primaryKey() -> String? {
        return "id"
    }

    override class func indexedProperties() -> [String] {
        return ["title", "content", "isArchived", "isStarred"]
    }

    func hydrate(from article: WallabagKitEntry) {
        if 0 == id {
            setValue(article.id, forKey: "id")
        }
        title = article.title
        content = article.content
        createdAt = Date.fromISOString(article.createdAt)
        updatedAt = Date.fromISOString(article.updatedAt)
        domainName = article.domainName
        isArchived = article.isArchived == 1
        isStarred = article.isStarred == 1
        previewPicture = article.previewPicture
        url = article.url
        readingTime = article.readingTime ?? 0
    }
}
