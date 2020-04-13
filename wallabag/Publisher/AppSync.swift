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
    private var cancellable = Set<AnyCancellable>()
    private var backgroundContext: NSManagedObjectContext = {
        let context = CoreData.shared.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()

    private var entriesSynced: [Int] = []
    private var tags: [Int: Tag] = [:]

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
    }
}

// MARK: Entry
extension AppSync {
    private func synchronizeEntries() {
        let progressSubject = PassthroughSubject<Publishers.ScrollPublisher.Output, Error>()
        progressSubject.map { Float($0.0.0) / Float($0.0.1) * 100 }
            .replaceError(with: 0)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveCompletion: { completion in
                if completion == .finished {
                    self.inProgress = false
                }
            })
            .assign(to: \.progress, on: self)
            .store(in: &cancellable)

        let entriesSubject = PassthroughSubject<Publishers.ScrollPublisher.Output, Error>()
        entriesSubject.map { $0.1 }
            .replaceError(with: [])
            .sink(receiveCompletion: { completion in
                if completion == .finished {
                    try? self.backgroundContext.save()
                    self.backgroundContext.reset()
                    self.purge()
                }
            }, receiveValue: handleEntries(_:))
            .store(in: &cancellable)

        let scroll = Publishers.ScrollPublisher(kit: session.kit)
            .share()

        scroll.subscribe(entriesSubject)
            .store(in: &cancellable)
        scroll.subscribe(progressSubject)
            .store(in: &cancellable)
    }

    private func handleEntries(_ wallabagEntries: [WallabagEntry]) {
        wallabagEntries.forEach { wallabagEntry in
            self.entriesSynced.append(wallabagEntry.id)
            if let entry = try? self.backgroundContext.fetch(Entry.fetchOneById(wallabagEntry.id)).first {
                self.update(entry, with: wallabagEntry)
            } else {
                self.insert(wallabagEntry)
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

// MARK: Tag
extension AppSync {
    private func applyTag(from wallabagEntry: WallabagEntry, to entry: Entry) {
        wallabagEntry.tags?.forEach { tag in
            entry.tags.insert(self.tags[tag.id]!)
        }
    }

    private func synchronizeTags() {
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
            })
        .store(in: &cancellable)
    }
}
