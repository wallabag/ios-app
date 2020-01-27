//
//  CoreDataSync.swift
//  wallabag
//
//  Created by Marinel Maxime on 17/01/2020.
//

import Combine
import CoreData
import Foundation

class CoreDataSync {
    private var objectsDidChangeCancellable: AnyCancellable?

    @Injector var appState: AppState

    init() {
        objectsDidChangeCancellable = NotificationCenter.default
            .publisher(for: .NSManagedObjectContextObjectsDidChange)
            .sink { notification in
                if let updatedObjs = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject>, !updatedObjs.isEmpty {
                    self.updatedObjects(updatedObjs)
                }

                if let deletedObjs = notification.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject>, !deletedObjs.isEmpty {
                    self.deletedObjects(deletedObjs)
                }
            }
    }

    // swiftlint:disable force_cast
    private func deletedObjects(_ deletedObjects: Set<NSManagedObject>) {
        deletedObjects
            .filter { $0 is Entry }
            .map { entry -> Entry in entry as! Entry }
            .forEach { entry in
                self.appState.session.delete(entry: entry)
            }
    }

    private func updatedObjects(_ updatedObjects: Set<NSManagedObject>) {
        updatedObjects.forEach { [unowned self] object in
            var changedValues = object.changedValuesForCurrentEvent()

            // MARK: ENTRY

            if let entry = object as? Entry {
                // skip tag at this time
                changedValues.removeValue(forKey: "tags")
                if changedValues.count > 0 {
                    self.appState.session.update(
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
