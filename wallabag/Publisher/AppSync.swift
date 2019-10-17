//
//  AppSync.swift
//  wallabag
//
//  Created by Marinel Maxime on 15/10/2019.
//

import Combine
import Foundation
import RealmSwift

class AppSync: ObservableObject {
    @Injector var realm: Realm
    @Injector var session: WallabagSession
    @Published var inProgress = false

    private var sessionState: AnyCancellable?
    private let syncQueue = DispatchQueue(label: "fr.district-web.wallabag.sync-queue", qos: .userInitiated)
    private var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Sync operation queue"
        queue.qualityOfService = .userInitiated
        return queue
    }()

    private let dispatchGroup = DispatchGroup()
    private var entriesSynced: [Int] = []

    deinit {
        sessionState?.cancel()
    }

    func requestSync() {
        inProgress = true
        sessionState = session.$state.sink { state in
            if state == .connected {
                self.sync()
            }
        }
        session.requestSession()
    }

    private func sync() {
        entriesSynced = []
        fetchEntries { collection in
            self.realm.beginWrite()
            for wallabagEntry in collection.items {
                self.entriesSynced.append(wallabagEntry.id)
                if let entry = self.realm.object(ofType: Entry.self, forPrimaryKey: wallabagEntry.id) {
                    if let articleUpdatedAt = Date.fromISOString(wallabagEntry.updatedAt) {
                        if entry.updatedAt! > articleUpdatedAt {
                            self.update(entry: entry)
                        }
                    }
                }
            }
            try? self.realm.commitWrite()
        }
        dispatchGroup.notify(queue: syncQueue) {
            // self.purge()
            DispatchQueue.main.async {
                self.inProgress = false
            }
        }
    }

    private func fetchEntries(page: Int = 1, completion: @escaping (WallabagCollection<WallabagEntry>) -> Void) {
        dispatchGroup.enter()
        _ = session.kit.send(decodable: WallabagCollection<WallabagEntry>.self, to: WallabagEntryEndpoint.get(page: page))
            .sink(receiveCompletion: { completion in
                self.dispatchGroup.leave()
                print(completion)
                if case .failure = completion {}
            }, receiveValue: { collection in
                if collection.page < collection.pages {
                    self.fetchEntries(page: collection.page + 1) { completion($0) }
                }
                completion(collection)
            })
    }

    private func update(entry: Entry) {
        _ = session.kit.send(decodable: WallabagEntry.self, to: WallabagEntryEndpoint.update(id: entry.id, parameters: [
            "archive": entry.isArchived.int,
            "starred": entry.isStarred.int,
        ])).sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }

    private func purge() {
        DispatchQueue.main.async { [unowned self] in
            do {
                let realmPurge = try Realm()
                try realmPurge.write {
                    let entries = realmPurge.objects(Entry.self).filter("NOT (id IN %@)", self.entriesSynced)
                    realmPurge.delete(entries)
                }
            } catch _ {}
        }
    }
}
