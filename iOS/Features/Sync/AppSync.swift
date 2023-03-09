import Combine
import CoreData
import Factory
import Foundation
import WallabagKit
import SharedLib

final class AppSync: ObservableObject {
    @Injected(\.wallabagSession) private var session
    @Injected(\.errorHandler) private var errorViewModel
    @Injected(\.coreData) private var coreData
    @CoreDataViewContext var coreDataContext: NSManagedObjectContext

    @Published private(set) var inProgress = false
    @Published private(set) var progress: Float = 0.0

    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = coreData.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()

    private var entriesSynced: [Int] = []
    private var tags: [Int: Tag] = [:]

    func requestSync() {
        progress = 0
        entriesSynced = []
        Task.detached(priority: .userInitiated) { [unowned self] in
            await synchronizeEntries()
            await synchronizeTags()
            purge()
            await MainActor.run {
                self.inProgress = false
            }
        }
        inProgress = true
    }
}

// MARK: - Entry

extension AppSync {
    func synchronizeEntries() async {
        let itemPerPages = WallabagUserDefaults.itemPerPageDuringSync
        let sequence = EntriesFetcher(session.kit, perPage: itemPerPages)
        do {
            for try await data in sequence {
                handleEntries(data.0)
                await MainActor.run {
                    self.progress = data.1
                }
                try backgroundContext.save()
            }
        } catch {
            errorViewModel.setLast(.wallabagKitError(error))
        }
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

    private func fetchTags() async throws -> [WallabagTag] {
        let request = session.kit.request(for: WallabagTagEndpoint.get, withAuth: true)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try session.kit.decoder.decode([WallabagTag].self, from: data)
    }

    private func synchronizeTags() async {
        do {
            try await fetchTags().forEach { wallabagTag in
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
        } catch _ {}
    }
}
