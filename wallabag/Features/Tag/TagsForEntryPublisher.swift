import Combine
import CoreData
import Foundation

// swiftlint:disable all
class TagsForEntryPublisher: ObservableObject {
    var objectWillChange = PassthroughSubject<Void, Never>()

    var tags: [Tag]
    var entry: Entry

    @CoreDataViewContext var coreDataContext: NSManagedObjectContext
    @Injector var appState: AppState

    init(entry: Entry) {
        self.entry = entry
        tags = try! CoreData.shared.viewContext.fetch(Tag.fetchRequestSorted())

        tags.filter { tag in
            entry.tags.contains(tag)
        }.forEach { $0.isChecked = true }
    }

    func add(tag: Tag) {
        add(tag: tag.label)
        tag.isChecked = true
    }

    func add(tag: String) {
        appState.session.add(tag: tag, for: entry)
        objectWillChange.send()
    }

    func delete(tag: Tag) {
        tag.isChecked = false
        tag.objectWillChange.send()
        appState.session.delete(tag: tag, for: entry)
    }
}
