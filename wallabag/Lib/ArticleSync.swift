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

final class ArticleSync {
    enum State {
        case finished, running, error
    }
    private let syncQueue = DispatchQueue(label: "fr.district-web.wallabag.articleSyncQueue", qos: .background)
    private let operationQueue = OperationQueue()
    private let group = DispatchGroup()
    private let spotlightObserver = SpotlightObserver()

    private var entries: [Entry] = []

    static let sharedInstance: ArticleSync = ArticleSync()

    var wallabagApi: WallabagApi?
    var state: State = .finished
    var pageCompleted: Int = 1
    var maxPage: Int = 1

    private init() {}

    func initSession() {
        wallabagApi = WallabagApi(host: Setting.getHost()!,
                    username: Setting.getUsername()!,
                    password: Setting.getPassword(username: Setting.getUsername()!)!,
                    clientId: Setting.getClientId()!,
                    clientSecret: Setting.getClientSecret()!)
    }

    func sync(completion: @escaping (State) -> Void) {
        if state == .running {
            return
        }
        state = .running

        entries = (CoreData.shared.fetch(Entry.fetchEntryRequest()) as? [Entry]) ?? []
        let totalEntries = entries.count

        group.enter()

        wallabagApi?.entry(parameters: ["page": 1]) { result in
            switch result {
            case .success(let collection):
                self.handle(result: collection.items)
                self.maxPage = collection.last
                completion(.running)

                for page in 2...collection.last {
                    self.group.enter()

                    let syncOperation = SyncOperation(articleSync: self, page: page)
                    syncOperation.completionBlock = {
                        self.pageCompleted += 1
                        completion(.running)
                        self.group.leave()
                    }
                    self.operationQueue.addOperation(syncOperation)
                }
            case .error(let error):
                if error == .invalidAuth {
                    completion(.error)
                }
            }
            self.group.leave()
        }

        group.notify(queue: syncQueue) {
            if self.entries.count != totalEntries {
               self.purge()
            }
            self.state = .finished
            self.pageCompleted = 1
            completion(.finished)
        }
    }

    func handle(result: [WallabagEntry]) {
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

    func insert(_ wallabagEntry: WallabagEntry) {
        CoreData.shared.performBackgroundTask { context in
            let entry = Entry(context: context)
            NSLog("Insert article \(wallabagEntry.id)")
            entry.hydrate(from: wallabagEntry)

            try? context.save()

        }
    }

    private func update(entry: Entry, from article: WallabagEntry) {
        guard let entryUpdatedAt = entry.value(forKey: "updated_at") as? Date else {
            return
        }

        if entryUpdatedAt != article.updatedAt {
            NSLog("Update article \(article.id)")
            if article.updatedAt > entryUpdatedAt {
                NSLog("Update entry from server \(article.id)")
                entry.hydrate(from: article)
            } else {
                NSLog("Update article from entry \(article.id)")
                update(entry: entry)
            }
        }
    }

    func update(entry: Entry) {
        // push data to server
        entry.updated_at = NSDate()
        wallabagApi?.entry(update: Int(entry.id), parameters: [
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
            wallabagApi?.entry(delete: Int(entry.id)) { _ in
            }
        }
        //CoreData.delete(entry)
    }

    func add(url: URL) {
        wallabagApi?.entry(add: url) { result in
            switch result {
            case .success(let wallabagEntry):
                self.insert(wallabagEntry)
            case .error:
                break
            }
        }
    }
}
