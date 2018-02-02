//
//  Entry+CoreDataProperties.swift
//  wallabag
//
//  Created by maxime marinel on 08/05/2017.
//  Copyright © 2017 maxime marinel. All rights reserved.
//

import Foundation
import CoreData
import WallabagKit

extension Entry {

    @nonobjc public class func fetchEntryRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var content: String?
    @NSManaged public var created_at: NSDate?
    @NSManaged public var domain_name: String?
    @NSManaged public var id: Int64
    @NSManaged public var is_archived: Bool
    @NSManaged public var is_starred: Bool
    @NSManaged public var preview_picture: String?
    @NSManaged public var title: String?
    @NSManaged public var updated_at: NSDate?
    @NSManaged public var url: String?
    @NSManaged public var reading_time: Int64
    @NSManaged public var screen_position: Float

    func hydrate(from article: WallabagEntry) {
        setValue(article.id, forKey: "id")
        setValue(article.title, forKey: "title")
        setValue(article.content, forKey: "content")
        setValue(article.createdAt, forKey: "created_at")
        setValue(article.updatedAt, forKey: "updated_at")
        setValue(article.isStarred, forKey: "is_starred")
        setValue(article.isArchived, forKey: "is_archived")
        setValue(article.previewPicture, forKey: "preview_picture")
        setValue(article.domainName, forKey: "domain_name")
        setValue(article.readingTime, forKey: "reading_time")
        setValue(article.url, forKey: "url")
    }
}
