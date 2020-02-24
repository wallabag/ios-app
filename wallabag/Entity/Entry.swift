//
//  Entry.swift
//  wallabag
//
//  Created by maxime marinel on 27/02/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import CoreData
import CoreSpotlight
import Foundation
import MobileCoreServices

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
    @NSManaged public var tags: Set<Tag>
}

extension Entry {
    var spotlightIdentifier: String {
        "\(Bundle.main.bundleIdentifier!).spotlight.\(Int(id))"
    }

    var searchableItemAttributeSet: CSSearchableItemAttributeSet {
        let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        searchableItemAttributeSet.title = title
        searchableItemAttributeSet.contentDescription = content?.withoutHTML

        return searchableItemAttributeSet
    }

    func hydrate(from article: WallabagEntry) {
        id = article.id
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

    func toggleArchive() {
        isArchived.toggle()
        objectWillChange.send()
    }

    func toggleStarred() {
        isStarred.toggle()
        objectWillChange.send()
    }

    var screenPositionForWebView: Double {
        if screenPosition < 0 {
            return 0.0
        }
        return Double(screenPosition)
    }
}
