import Combine
import CoreData
import Factory
import Foundation
import SharedLib

class CoreDataSync {
    private var objectsDidChangeCancellable: AnyCancellable?

    @Injected(\.appSync) private var appSync
    @Injected(\.wallabagSession) var wallabagSession

    init() {
        objectsDidChangeCancellable = NotificationCenter.default
            .publisher(for: .NSManagedObjectContextObjectsDidChange)
            .receive(on: DispatchQueue.main)
            .sink { notification in
                if !self.appSync.inProgress {
                    if let updatedObjs = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject>, !updatedObjs.isEmpty {
                        self.updatedObjects(updatedObjs)
                    }

                    if let deletedObjs = notification.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject>, !deletedObjs.isEmpty {
                        self.deletedObjects(deletedObjs)
                    }
                }
            }
    }

    private func deletedObjects(_ deletedObjects: Set<NSManagedObject>) {
        deletedObjects
            .compactMap { $0 as? Entry }
            .forEach { entry in
                self.wallabagSession.delete(entry: entry)
            }
    }

    private func updatedObjects(_ updatedObjects: Set<NSManagedObject>) {
        updatedObjects.forEach { [unowned self] object in
            var changedValues = object.changedValues()

            // MARK: ENTRY

            if let entry = object as? Entry {
                // skip tag at this time
                changedValues.removeValue(forKey: "tags")
                if changedValues.count > 0 {
                    logger.debug("Push update entry \(entry.id) to remote")
                    wallabagSession.update(
                        entry,
                        parameters:
                        [
                            "archive": entry.isArchived.int,
                            "starred": entry.isStarred.int,
                        ]
                    )
                }
            }

            // MARK: TAG
        }
    }
}
