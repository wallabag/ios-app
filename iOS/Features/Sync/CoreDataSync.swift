import Combine
import CoreData
import Foundation
import SharedLib

class CoreDataSync {
    private var objectsDidChangeCancellable: AnyCancellable?

    @Injector var appSync: AppSync
    @Injector var wallabagSession: WallabagSession

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

    // swiftlint:disable force_cast
    private func deletedObjects(_ deletedObjects: Set<NSManagedObject>) {
        deletedObjects
            .filter { $0 is Entry }
            .map { entry -> Entry in entry as! Entry }
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
                    self.wallabagSession.update(
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
