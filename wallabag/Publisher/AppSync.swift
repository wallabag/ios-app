//
//  AppSync.swift
//  wallabag
//
//  Created by Marinel Maxime on 15/10/2019.
//

import Combine
import Foundation
import RealmSwift
import CoreData

class AppSync: ObservableObject {
    @Injector var realm: Realm
    @Injector var session: WallabagSession
    @Published var inProgress = false
    @CoreDataViewContext var coreDataContext: NSManagedObjectContext
    
    private var sessionState: AnyCancellable?
    private let syncQueue = DispatchQueue(label: "fr.district-web.wallabag.sync-queue", qos: .userInitiated)
    
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
            for wallabagEntry in collection.items {
                
                if let entry = try? self.coreDataContext.fetch(Entry.fetchOneById(wallabagEntry.id)).first {
                    if let articleUpdatedAt = Date.fromISOString(wallabagEntry.updatedAt) {
                        if entry.updatedAt! > articleUpdatedAt {
                            self.update(entry: entry)
                        }
                    }
                }
                let entry = Entry(context: self.coreDataContext)
                entry.hydrate(from: wallabagEntry)
            }
        }
        dispatchGroup.notify(queue: syncQueue) {
            self.purge()
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
                /*try self.realm.write {
                 let entries = self.realm.objects(Entry.self).filter("NOT (id IN %@)", self.entriesSynced)
                 self.realm.delete(entries)
                 }*/
            } catch _ {}
        }
    }
}
