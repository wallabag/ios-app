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

final class ArticleSync: NSObject {
    private let syncQueue = DispatchQueue(label: "fr.district-web.wallabag.articleSyncQueue", attributes: .concurrent)
    private let spotlightQueue = DispatchQueue(label: "fr.district-web.wallabag.spotlightQueue", qos: .background)

    func sync() {
        syncQueue.async(flags: .barrier) {
            WallabagApi.Entry.fetch(with: ["page": 1 ]) { results in
                switch results {
                case .success(let data):
                    guard let page = data["pages"] as? Int else {
                        return
                    }
                    for page in 2...page {
                        self.fetch(page: page)
                    }
                    self.handle(result: data)
                case .failure: break
                }
            }
        }
    }

    private func fetch(page: Int) {
        syncQueue.async {
            WallabagApi.Entry.fetch(with: ["page": page ]) { results in
                switch results {
                case .success(let data):
                    self.handle(result: data)
                case .failure: break
                }
            }
        }
    }

    private func handle(result: [String:Any]) {
        if let embedded = result["_embedded"] as? [String: Any] {
            for item in (embedded["items"] as? [[String: Any]])! {
                let article = Article(fromDictionary: item)
                let fetchRequest = Entry.fetchEntryRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", article.id as NSNumber)
                let results = (CoreData.fetch(fetchRequest) as? [Entry]) ?? []
                if 0 == results.count {
                    print("insert article")
                    self.insert(article)
                } else {
                    self.update(entry: results.first!, from: article)
                }
            }
        }
    }

    func insert(_ article: Article) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Entry", in: CoreData.context)!
        let entry = Entry.init(entity: entityDescription, insertInto: CoreData.context)
        log.debug("Insert article \(article.id)")
        setDataFor(entry: entry, from: article)
    }

    private func setDataFor(entry: Entry, from article: Article) {
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

        index(entry: entry)

        CoreData.saveContext()
    }

    private func update(entry: Entry, from article: Article) {
        guard let entryUpdatedAt = entry.value(forKey: "updated_at") as? Date else {
            return
        }

        if entryUpdatedAt != article.updatedAt {
            log.debug("Update article \(article.id)")
            if article.updatedAt > entryUpdatedAt {
                log.debug("Update entry from server \(article.id)")
                setDataFor(entry: entry, from: article)
            } else {
                log.debug("Update article from entry \(article.id)")
                update(entry: entry)
            }
        }
    }

    func update(entry: Entry) {
        // push data to server
        entry.updated_at = NSDate()
        CoreData.saveContext()
        WallabagApi.Entry.update(id: Int(entry.id), with: [
            "archive": (entry.is_archived).hashValue,
            "starred": (entry.is_starred).hashValue
            ]
        ) { results in
            switch results {
            case .success(let data):
                let article = Article(fromDictionary: data)
                entry.setValue(article.updatedAt, forKey: "updated_at")
                CoreData.saveContext()
            case .failure: break
            }
        }
    }

    func delete(entry: Entry) {
        log.info("Delete entry \(entry.id)")
        do {
            WallabagApi.Entry.delete(id: Int(entry.id)) { _ in
            }
            try CoreData.delete(entry)
            spotlightQueue.async {
                CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [entry.spotlightIdentifier], completionHandler: nil)
            }
        } catch {
        }
    }

    func add(url: URL) {
        WallabagApi.addArticle(url) { article in
            self.insert(article)
        }
    }

    private func index(entry: Entry) {
        spotlightQueue.async {
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
}
