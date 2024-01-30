import CoreData
import Factory
import Foundation

@Observable
final class TagsForEntryViewModel {
    @ObservationIgnored
    @Injected(\.wallabagSession) private var session

    var tags: [Tag] = []
    var entry: Entry?
    var isLoading = false

    @ObservationIgnored
    @CoreDataViewContext var coreDataContext: NSManagedObjectContext

    @MainActor
    func load(for entry: Entry) async {
        tags = (try? coreDataContext.fetch(Tag.fetchRequestSorted())) ?? []
        tags.filter { tag in
            entry.tags.contains(tag)
        }.forEach {
            $0.isChecked = true
        }
    }

    func toggle(tag: Tag, for entry: Entry) async {
        defer {
            isLoading = false
        }
        isLoading = true
        if tag.isChecked {
            await delete(tag: tag, for: entry)
        } else {
            await add(tag: tag, for: entry)
        }

        await load(for: entry)
    }

    func add(tag: String, for entry: Entry) async {
        try? await session.add(tag: tag, for: entry)
        await load(for: entry)
    }

    private func add(tag: Tag, for entry: Entry) async {
        await add(tag: tag.label, for: entry)
        tag.isChecked = true
    }

    private func delete(tag: Tag, for entry: Entry) async {
        tag.isChecked = false
        try? await session.delete(tag: tag, for: entry)
    }
}
