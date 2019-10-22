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
    
    func requestSync(completion: @escaping () -> ()) {
        inProgress = true
        sessionState = session.$state.sink { state in
            if state == .connected {
                self.sync {
                    completion()
                }
            }
        }
        session.requestSession()
    }
    
    private func sync(completion: @escaping () -> ()) {
        entriesSynced = []
        fetchEntries { collection in
            CoreData.shared.persistentContainer.performBackgroundTask { backgroundContext in
                for wallabagEntry in collection.items {
                    self.entriesSynced.append(wallabagEntry.id)
                    if let entry = try? self.coreDataContext.fetch(Entry.fetchOneById(wallabagEntry.id)).first {
                        if let articleUpdatedAt = Date.fromISOString(wallabagEntry.updatedAt) {
                            if entry.updatedAt! > articleUpdatedAt {
                                self.update(entry: entry)
                            }
                        }
                    } else {
                        let entry = Entry(context: backgroundContext)
                        entry.hydrate(from: wallabagEntry)
                    }
                }
                do {
                    try backgroundContext.save()
                } catch {
                    
                }
            }
        }
        dispatchGroup.notify(queue: syncQueue) {
            self.purge()
            DispatchQueue.main.async {
                self.inProgress = false
                completion()
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        fetchRequest.predicate = NSPredicate(format: "NOT (id IN %@)", argumentArray: [self.entriesSynced])
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        CoreData.shared.persistentContainer.performBackgroundTask { backgroundContext in
            do {
                let batchDeleteResult = try backgroundContext.execute(deleteRequest) as? NSBatchDeleteResult
                
                if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                                        into: [self.coreDataContext])
                }
            } catch {
                Log("Error in batch delete")
            }
        }
    }
}
