//
//  Entry.swift
//  wallabag
//
//  Created by maxime marinel on 27/02/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation
import RealmSwift

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
    public let tags = List<Tag>()

    override class func primaryKey() -> String? {
        return "id"
    }

    override class func indexedProperties() -> [String] {
        return ["title", "content", "isArchived", "isStarred"]
    }
}
