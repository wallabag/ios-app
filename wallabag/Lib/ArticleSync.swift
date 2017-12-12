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

final class ArticleSync {
    private let syncQueue = DispatchQueue(label: "fr.district-web.wallabag.articleSyncQueue", qos: .background)
    private let spotlightQueue = DispatchQueue(label: "fr.district-web.wallabag.spotlightQueue", qos: .background)
    private let group = DispatchGroup()

    private var entries: [Entry] = []

    private var isSyncing: Bool = false

    static let sharedInstance: ArticleSync = ArticleSync()

    var wallabagApi: WallabagApi = {
        return WallabagApi(host: Setting.getHost()!,
                           username: Setting.getUsername()!,
                           password: Setting.getPassword()!,
                           clientId: Setting.getClientId()!,
                           clientSecret: Setting.getClientSecret()!)
    }()

    var page = 1

    private init() {}

    func sync() {
        if isSyncing {
            return
        }
        entries = (CoreData.fetch(Entry.fetchEntryRequest()) as? [Entry]) ?? []
        isSyncing = true

        self.fetch(page: 1)

        group.notify(queue: syncQueue) { [unowned self] in
            CoreData.saveContext()
            self.purge()
            self.page = 1
            self.isSyncing = false
        }
    }

    private func fetch(page: Int) {
        self.group.enter()
        wallabagApi.entry(parameters: ["page": page, "perPage": 10]) { result in
            switch result {
            case .success(let entries):
                self.handle(result: entries)
                if 0 != entries.count {
                    self.page += 1
                    self.fetch(page: self.page)
                }
            case .error:
                NSLog("error")
            }
            self.group.leave()
        }
    }

    private func handle(result: [WallabagEntry]) {
        for wallabagEntry in result {
            if let entry = entries.first(where: { Int($0.id) == wallabagEntry.id }) {
                self.update(entry: entry, from: wallabagEntry)
            } else {
                self.insert(wallabagEntry)
            }

            if let index = entries.index(where: { Int($0.id) == wallabagEntry.id }) {
                entries.remove(at: index)
            }
        }
    }

    private func purge() {
        for entry in entries {
            delete(entry: entry, callServer: false)
        }
    }

    func insert(_ article: WallabagEntry) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Entry", in: CoreData.context)!
        let entry = Entry.init(entity: entityDescription, insertInto: CoreData.context)
        NSLog("Insert article \(article.id)")
        setDataFor(entry: entry, from: article)
    }

    private func setDataFor(entry: Entry, from article: WallabagEntry) {
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
    }

    private func update(entry: Entry, from article: WallabagEntry) {
        guard let entryUpdatedAt = entry.value(forKey: "updated_at") as? Date else {
            return
        }

        if entryUpdatedAt != article.updatedAt {
            NSLog("Update article \(article.id)")
            if article.updatedAt > entryUpdatedAt {
                NSLog("Update entry from server \(article.id)")
                setDataFor(entry: entry, from: article)
            } else {
                NSLog("Update article from entry \(article.id)")
                update(entry: entry)
            }
        }
    }

    func update(entry: Entry) {
        // push data to server
        entry.updated_at = NSDate()
        wallabagApi.entry(update: Int(entry.id), parameters: [
            "archive": (entry.is_archived).hashValue,
            "starred": (entry.is_starred).hashValue
            ]
        ) { results in
            switch results {
            case .success(let wallabagEntry):
                entry.setValue(wallabagEntry.updatedAt, forKey: "updated_at")
            case .error: break
            }
        }
    }

    func delete(entry: Entry, callServer: Bool = true) {
        NSLog("Delete entry \(entry.id)")
        if callServer {
            wallabagApi.entry(delete: Int(entry.id)) { _ in
            }
        }
        CoreData.delete(entry)
        spotlightQueue.async {
            CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [entry.spotlightIdentifier], completionHandler: nil)
        }
    }

    func add(url: URL) {
        wallabagApi.entry(add: url) { result in
            switch result {
            case .success(let wallabagEntry):
                self.insert(wallabagEntry)
            case .error:
                break
            }
        }
    }

    private func index(entry: Entry) {
        spotlightQueue.async {
            NSLog("Spotlight entry \(entry.id)")
            let searchableItem = CSSearchableItem(uniqueIdentifier: entry.spotlightIdentifier,
                                                  domainIdentifier: "entry",
                                                  attributeSet: entry.searchableItemAttributeSet
            )

            CSSearchableIndex.default().indexSearchableItems([searchableItem]) { (error) -> Void in
                if error != nil {
                    NSLog(error!.localizedDescription)
                }
            }
        }
    }
}
