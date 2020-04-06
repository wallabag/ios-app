//
//  AppSync.swift
//  wallabag
//
//  Created by Marinel Maxime on 15/10/2019.
//

import Combine
import CoreData
import Foundation
import SwiftyLogger

class AppSync: ObservableObject {
    @Injector var session: WallabagSession
    @Injector var errorPublisher: ErrorPublisher
    @CoreDataViewContext var coreDataContext: NSManagedObjectContext

    @Published private(set) var inProgress = false
    @Published private(set) var progress: Float = 0.0

    private let syncQueue = DispatchQueue(label: "fr.district-web.wallabag.sync-queue", qos: .userInitiated)
    private let dispatchGroup = DispatchGroup()
    private var sessionState: AnyCancellable?
    private var cancellable = Set<AnyCancellable>()
    private var backgroundContext: NSManagedObjectContext = {
        let context = CoreData.shared.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()

    private var entriesSynced: [Int] = []
    private var tags: [Int: Tag] = [:]

    deinit {
        sessionState?.cancel()
    }

    func requestSync() {
        inProgress = true
        session.$state.sink { state in
            switch state {
            case .connected:
                self.sync()
            case let .error(reason):
                DispatchQueue.main.async {
                    self.inProgress = false
                    self.errorPublisher.lastError = .syncError(reason)
                }
            default:
                break
            }
        }.store(in: &cancellable)
    }

    private func sync() {
        progress = 0.0
        entriesSynced = []

        synchronizeTags()
        synchronizeEntries()

        dispatchGroup.notify(queue: syncQueue) {
            Log("Sync end")
            do {
                try self.backgroundContext.save()
                self.backgroundContext.reset()
            } catch {}
            self.purge()
            DispatchQueue.main.async {
                self.inProgress = false
            }
        }
    }

    private func synchronizeEntries() {
        fetchEntries { collection in
            DispatchQueue.main.async { [unowned self] in
                self.progress = (Float(collection.page) / Float(collection.pages)) * 100.0
            }
            collection.items.forEach { wallabagEntry in
                self.entriesSynced.append(wallabagEntry.id)
                if let entry = try? self.backgroundContext.fetch(Entry.fetchOneById(wallabagEntry.id)).first {
                    self.update(entry, with: wallabagEntry)
                } else {
                    self.insert(wallabagEntry)
                }
            }
        }
    }

    private func insert(_ wallabagEntry: WallabagEntry) {
        let entry = Entry(context: backgroundContext)
        entry.hydrate(from: wallabagEntry)
        applyTag(from: wallabagEntry, to: entry)
    }

    private func update(_ entry: Entry, with wallabagEntry: WallabagEntry) {
        entry.hydrate(from: wallabagEntry)
        applyTag(from: wallabagEntry, to: entry)
    }

    private func applyTag(from wallabagEntry: WallabagEntry, to entry: Entry) {
        wallabagEntry.tags?.forEach { tag in
            entry.tags.insert(self.tags[tag.id]!)
        }
    }

    private func synchronizeTags() {
        dispatchGroup.enter()
        session.kit.send(
            decodable: [WallabagTag].self,
            to: WallabagTagEndpoint.get,
            onQueue: syncQueue
        )
        .receive(on: syncQueue)
        .sink(receiveCompletion: { _ in }, receiveValue: { tags in
            tags.forEach { wallabagTag in
                if let tag = try? self.backgroundContext.fetch(Tag.fetchOneById(wallabagTag.id)).first {
                    self.tags[tag.id] = tag
                } else {
                    let tag = Tag(context: self.backgroundContext)
                    tag.id = wallabagTag.id
                    tag.label = wallabagTag.label
                    tag.slug = wallabagTag.slug
                    self.tags[wallabagTag.id] = tag
                }
            }
            self.dispatchGroup.leave()
            })
        .store(in: &cancellable)
    }

    private func fetchEntries(page: Int = 1, completion: @escaping (WallabagCollection<WallabagEntry>) -> Void) {
        dispatchGroup.enter()
        session.kit.send(
            decodable: WallabagCollection<WallabagEntry>.self,
            to: WallabagEntryEndpoint.get(page: page),
            onQueue: syncQueue
        )
        .receive(on: syncQueue)
        .sink(receiveCompletion: { _ in
            self.dispatchGroup.leave()
        }, receiveValue: { collection in
            if collection.page < collection.pages {
                self.fetchEntries(page: collection.page + 1) { collection in
                    completion(collection)
                }
            }
            completion(collection)
            }).store(in: &cancellable)
    }

    private func purge() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        fetchRequest.predicate = NSPredicate(format: "NOT (id IN %@)", argumentArray: [entriesSynced])
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        CoreData.shared.persistentContainer.performBackgroundTask { backgroundContext in
            do {
                let batchDeleteResult = try backgroundContext.execute(deleteRequest) as? NSBatchDeleteResult

                if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                                        into: [self.coreDataContext])
                }
                try? backgroundContext.save()
            } catch {
                Log("Error in batch delete")
            }
        }
    }
}
