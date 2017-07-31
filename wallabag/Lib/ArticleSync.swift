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
import CoreSpotlight
import MobileCoreServices

class ArticleSync: NSObject {
    private let syncQueue = DispatchQueue(label: "fr.district-web.wallabag.articleSyncQueue")
    private let spotlightQueue = DispatchQueue(label: "fr.district-web.wallabag.spotlightQueue", qos: .background)

    private var page = 1

    func sync() {
      //  fetch()
    }

    private func fetch(page: Int = 1) {
        syncQueue.async(execute: DispatchWorkItem {
            log.debug("Article sync work on page \(page)")
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
                    self.fetch(page: self.page)
                } else {
                    self.syncQueue.async(execute: DispatchWorkItem {
                        self.page = 1
                    })
                }

                CoreData.saveContext()
            }
        })
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

        spotlightQueue.async {
            self.index(entry: entry)
        }
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

    func delete(entry: Entry) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [entry.spotlightIdentifier], completionHandler: nil)
    }

    func index(entry: Entry) {
        log.debug("Spotlight entry \(entry.id)")
        let searchableItem = CSSearchableItem(uniqueIdentifier: entry.spotlightIdentifier,
                                              domainIdentifier: "entry",
                                              attributeSet: entry.searchableItemAttributeSet
        )

        CSSearchableIndex.default().indexSearchableItems([searchableItem]) { (error) -> Void in
            if error != nil {
                log.error(error!.localizedDescription)
            }
        }
    }
}
