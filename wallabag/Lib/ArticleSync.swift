//
//  ArticleSync.swift
//  wallabag
//
//  Created by maxime marinel on 07/05/2017.
//  Copyright © 2017 maxime marinel. All rights reserved.
//

import Foundation
import WallabagKit
import CoreData

class ArticleSync: NSObject {

    var page = 1

    func sync(page: Int = 1) {
        log.info("Start syncing")
        WallabagApi.retrieveArticle(page: page) { (articles, _) in
            for article in articles {
                let fetchRequest = Entry.fetchEntryRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", article.id as NSNumber)
                let results = (CoreData.fetch(fetchRequest) as? [Entry]) ?? []
                if 0 == results.count {
                    self.insert(article)
                } else {
                    self.update(entry: results.first!, article: article)
                }
            }
            if 0 != articles.count {
                self.page += 1
                self.sync(page: self.page)
            }

            log.info("Sync end")
            CoreData.saveContext()
        }
    }

    func insert(_ article: Article) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Entry", in: CoreData.context)!
        let entry = Entry.init(entity: entityDescription, insertInto: CoreData.context)
        log.debug("Insert article \(article.id)")
        setDataForEntry(entry: entry, article: article)
    }

    func setDataForEntry(entry: Entry, article: Article) {
        entry.setValue(article.id, forKey: "id")
        entry.setValue(article.title, forKey: "title")
        entry.setValue(article.content, forKey: "content")
        entry.setValue(article.createdAt, forKey: "created_at")
        entry.setValue(article.updatedAt, forKey: "updated_at")
        entry.setValue(article.isStarred, forKey: "is_starred")
        entry.setValue(article.isArchived, forKey: "is_archived")
        entry.setValue(article.previewPicture, forKey: "preview_picture")
        entry.setValue(article.domainName, forKey: "domain_name")
        entry.setValue(article.readingTime, forKey: "reading_time")
        entry.setValue(article.url, forKey: "url")
    }

    func update(entry: Entry, article: Article) {
        guard let entryUpdatedAt = entry.value(forKey: "updated_at") as? Date else {
            return
        }

        if entryUpdatedAt != article.updatedAt {
            log.debug("Update article \(article.id)")
            setDataForEntry(entry: entry, article: article)
        }
    }

    func delete() {
    }
}
