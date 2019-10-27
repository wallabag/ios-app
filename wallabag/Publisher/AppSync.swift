//
//  AppSync.swift
//  wallabag
//
//  Created by Marinel Maxime on 15/10/2019.
//

import Combine
import CoreData
import Foundation

class AppSync: ObservableObject {
    @Injector var session: WallabagSession
    @Published var inProgress = false
    @CoreDataViewContext var coreDataContext: NSManagedObjectContext

    private var sessionState: AnyCancellable?
    private let syncQueue = DispatchQueue(label: "fr.district-web.wallabag.sync-queue", qos: .userInitiated)

    private let dispatchGroup = DispatchGroup()
    private var entriesSynced: [Int] = []
    private var tags: [Int: Tag] = [:]

    deinit {
        sessionState?.cancel()
    }

    func requestSync(completion: @escaping () -> Void) {
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

    private func sync(completion: @escaping () -> Void) {
        entriesSynced = []
        let backgroundContext = CoreData.shared.persistentContainer.newBackgroundContext()
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        fetchEntries { collection in
            for wallabagEntry in collection.items {
                self.entriesSynced.append(wallabagEntry.id)
                if let entry = try? backgroundContext.fetch(Entry.fetchOneById(wallabagEntry.id)).first {
                    entry.hydrate(from: wallabagEntry)
                    if let articleUpdatedAt = Date.fromISOString(wallabagEntry.updatedAt) {
                        if entry.updatedAt! > articleUpdatedAt {
                            self.update(entry: entry)
                        }
                    }

                } else {
                    let entry = Entry(context: backgroundContext)
                    entry.hydrate(from: wallabagEntry)
                    let entryTags = entry.mutableSetValue(forKey: #keyPath(Entry.tags))
                    wallabagEntry.tags?.forEach {
                        if let tag = self.tags[$0.id] {
                            entryTags.add(tag)
                        } else {
                            let tag = Tag(context: backgroundContext)
                            tag.id = $0.id
                            tag.label = $0.label
                            tag.slug = $0.slug
                            entryTags.add(tag)
                            self.tags[$0.id] = tag
                        }
                    }
                }
            }
        }

        dispatchGroup.notify(queue: syncQueue) {
            do {
                try backgroundContext.save()
                backgroundContext.reset()
            } catch {}
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
