//
//  Entry.swift
//  wallabag
//
//  Created by maxime marinel on 27/02/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation
import RealmSwift
import CoreData


class Entry: NSManagedObject, Identifiable {}

extension Entry {
    @nonobjc public class func fetchRequestSorted() -> NSFetchRequest<Entry> {
        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    @nonobjc public class func fetchOneById(_ id: Int) -> NSFetchRequest<Entry> {
        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
        fetchRequest.predicate = NSPredicate(format: "id == %ld", id)
        return fetchRequest
    }

    @NSManaged public dynamic var content: String?
    @NSManaged public dynamic var createdAt: Date?
    @NSManaged public dynamic var domainName: String?
    @NSManaged public dynamic var id: Int
    @NSManaged public dynamic var isArchived: Bool
    @NSManaged public dynamic var isStarred: Bool
    @NSManaged public dynamic var previewPicture: String?
    @NSManaged public dynamic var title: String?
    @NSManaged public dynamic var updatedAt: Date?
    @NSManaged public dynamic var url: String?
    @NSManaged public dynamic var readingTime: Int
    @NSManaged public dynamic var screenPosition: Float
}

/*
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
}*/
