import Combine
import CoreData
import Factory
import Foundation

// swiftlint:disable:next all
class TagsForEntryPublisher: ObservableObject {
    @Injected(\.wallabagSession) private var session

    var objectWillChange = PassthroughSubject<Void, Never>()

    var tags: [Tag]
    var entry: Entry

    @CoreDataViewContext var coreDataContext: NSManagedObjectContext

    init(entry: Entry) {
        self.entry = entry
        tags = (try? Container.shared.coreData().viewContext.fetch(Tag.fetchRequestSorted())) ?? []

        tags.filter { tag in
            entry.tags.contains(tag)
        }.forEach { $0.isChecked = true }
    }

    func add(tag: Tag) async {
        await add(tag: tag.label)
        tag.isChecked = true
    }

    func add(tag: String) async {
        try? await session.add(tag: tag, for: entry)
        objectWillChange.send()
    }

    func delete(tag: Tag) async {
        tag.isChecked = false
        tag.objectWillChange.send()
        try? await session.delete(tag: tag, for: entry)
    }
}
