import Combine
import CoreData
import Foundation
import SwiftUI
import WallabagKit

class AppSync: ObservableObject {
    static var shared = AppSync()
    @Injector var session: WallabagSession
    @Injector var errorViewModel: ErrorViewModel
    @CoreDataViewContext var coreDataContext: NSManagedObjectContext

    @Published private(set) var inProgress = false
    @Published private(set) var progress: Float = 0.0

    private let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "fr.district-web.wallabag.sync-queue"
        queue.qualityOfService = .userInitiated
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    private var cancellable = Set<AnyCancellable>()
    private var backgroundContext: NSManagedObjectContext = {
        let context = CoreData.shared.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()

    private var entriesSynced: [Int] = []
    private var tags: [Int: Tag] = [:]

    func requestSync() {
        withAnimation {
            inProgress = true
        }
        sync()
    }

    private func sync() {
        progress = 0.0
        entriesSynced = []

        synchronizeTags()
        synchronizeEntries()
    }
}

// MARK: - Entry

extension AppSync {
    private func synchronizeEntries() {
        let errorSubject = PassthroughSubject<Publishers.ScrollPublisher.Output, WallabagKitError>()
        errorSubject
            .mapError { WallabagError.wallabagKitError($0) }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    self.errorViewModel.setLast(error)
                case .finished:
                    break
                }
            }, receiveValue: { _ in

            }).store(in: &cancellable)
        let progressSubject = PassthroughSubject<Publishers.ScrollPublisher.Output, WallabagKitError>()
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

        let entriesSubject = PassthroughSubject<Publishers.ScrollPublisher.Output, WallabagKitError>()
        entriesSubject.map(\.1)
            .replaceError(with: [])
            .handleEvents(receiveCompletion: { completion in
                if completion == .finished {
                    self.purge()
                    try? self.backgroundContext.save()
                    self.backgroundContext.reset()
                }
            })
            .sink(receiveValue: handleEntries(_:))
            .store(in: &cancellable)

        let scroll = Publishers.ScrollPublisher(kit: session.kit)
            .subscribe(on: operationQueue)
            .share()

        scroll.subscribe(errorSubject)
            .store(in: &cancellable)
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
        if entriesSynced.count == 0 {
            return
        }

        let fetchRequest = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "NOT (id IN %@)", argumentArray: [entriesSynced])

        do {
            let entriesToDelete = try backgroundContext.fetch(fetchRequest)
            for entryToDelete in entriesToDelete {
                guard let entryToDelete = entryToDelete as? NSManagedObject else { fatalError() }

                backgroundContext.delete(entryToDelete)
            }
        } catch {
            logger.error("Error in batch delete")
        }
    }

    func refresh(entry: Entry) {
        session.refresh(entry: entry)
    }
}

// MARK: - Tag

extension AppSync {
    private func applyTag(from wallabagEntry: WallabagEntry, to entry: Entry) {
        wallabagEntry.tags?.forEach { wallabagTag in
            guard let tag = self.tags[wallabagTag.id] else { return }
            entry.tags.insert(tag)
        }
    }

    private func synchronizeTags() {
        session.kit.send(to: WallabagTagEndpoint.get)
            .subscribe(on: operationQueue)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { (tags: [WallabagTag]) in
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
