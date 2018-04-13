//
//  ArticleSync.swift
//  wallabag
//
//  Created by maxime marinel on 07/05/2017.
//  Copyright © 2017 maxime marinel. All rights reserved.
//

import Foundation
import CoreData
import RealmSwift

final class ArticleSync {
    enum State {
        case finished, running, error
    }
    private let syncQueue = DispatchQueue(label: "fr.district-web.wallabag.articleSyncQueue", qos: .background)
    private var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .background
        return queue
    }()
    private let group = DispatchGroup()

    static let sharedInstance: ArticleSync = ArticleSync()

    var state: State = .finished
    var pageCompleted: Int = 1
    var maxPage: Int = 1

    var entriesSynced: [Int] = []

    private init() {}

    func sync(completion: @escaping (State) -> Void) {
        if state == .running {
            return
        }
        state = .running

        group.enter()
        WallabagKit.instance.entry(parameters: ["page": 1], queue: syncQueue) { response in
            switch response {
            case .success(let collection):
                self.maxPage = collection.pages
                completion(.running)
                self.handle(result: collection.items)

                for page in 2...self.maxPage {
                    self.group.enter()
                    let syncOperation = SyncOperation(articleSync: self, page: page, queue: self.syncQueue)
                    syncOperation.completionBlock = {
                        self.pageCompleted += 1
                        completion(.running)
                        self.group.leave()
                    }
                    self.operationQueue.addOperation(syncOperation)
                }
                break
            case .error:
                print("error")
                break
            }
            self.group.leave()
        }

        group.notify(queue: syncQueue) {
            self.state = .finished
            self.pageCompleted = 1
            completion(.finished)
            if 0 != self.entriesSynced.count {
                self.purge()
            }

            self.entriesSynced = []
        }
    }

    func handle(result: [WallabagKitEntry]) {
        let realm = try! Realm()
        realm.beginWrite()
        for wallabagEntry in result {
            entriesSynced.append(wallabagEntry.id)
            if let entry = realm.object(ofType: Entry.self, forPrimaryKey: wallabagEntry.id) {
                self.update(entry: entry, from: wallabagEntry)
            } else {
                self.insert(wallabagEntry, realm)
            }
        }
        try? realm.commitWrite()
    }

    private func purge() {
        let realmPurge = try! Realm()
        try! realmPurge.write {
            let entries = realmPurge.objects(Entry.self).filter("NOT (id IN %@)", entriesSynced)
            realmPurge.delete(entries)
        }
    }

    func insert(_ wallabagEntry: WallabagKitEntry, _ realm: Realm) {
        let entry = Entry()
        NSLog("Insert article \(wallabagEntry.id)")
        entry.hydrate(from: wallabagEntry)
        realm.add(entry)
    }

    private func update(entry: Entry, from article: WallabagKitEntry) {
        let articleUpdatedAt = Date.fromISOString(article.updatedAt)!
        if entry.updatedAt != articleUpdatedAt {
            if articleUpdatedAt > entry.updatedAt! {
                entry.hydrate(from: article)
            } else {
                update(entry: entry)
            }
        }
    }

    /**
     * Push data to server
     */
    func update(entry: Entry) {
        let entryRef = ThreadSafeReference(to: entry)
        WallabagKit.instance.entry(
            update: entry.id,
            parameters: [
                "archive": entry.isArchived.hashValue,
                "starred": entry.isStarred.hashValue
            ],
            queue: syncQueue) { response in
                switch response {
                case .success(let entryFromServer):
                    let realm = try! Realm()
                    if let entry = realm.resolve(entryRef) {
                        try! realm.write {
                            entry.updatedAt = Date.fromISOString(entryFromServer.updatedAt)
                        }
                    }
                    break
                case .error:
                    break
                }
        }
    }

    func delete(entry: Entry, callServer: Bool = true) {
        NSLog("Delete entry \(entry.id)")
        if callServer {
            WallabagKit.instance.entry(delete: entry.id) {}
        }
        let realm = try! Realm()
        try! realm.write {
            realm.delete(entry)
        }
    }

    func add(url: URL) {
        WallabagKit.instance.entry(add: url, queue: syncQueue) { response in
            switch response {
            case .success(let entry):
                let realm = try! Realm()
                try! realm.write {
                    self.insert(entry, realm)
                }
            case .error:
                break
            }
        }
    }
}
