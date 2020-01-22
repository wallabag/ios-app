//
//  CoreDataSync.swift
//  wallabag
//
//  Created by Marinel Maxime on 17/01/2020.
//

import Foundation
import Combine
import CoreData

class CoreDataSync {
    private var objectsDidChangeCancellable: AnyCancellable?
    
    @Injector var appState: AppState
    
    init() {
        objectsDidChangeCancellable = NotificationCenter.default
            .publisher(for: .NSManagedObjectContextObjectsDidChange)
            .sink { notification in
                if let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject>, !updatedObjects.isEmpty {
                    updatedObjects.forEach { [unowned self] object in
                        if let entry = object as? Entry {
                            var changedValues = object.changedValuesForCurrentEvent()
                            changedValues.removeValue(forKey: "tags")
                            if changedValues.count > 0 {
                                self.appState.session.update(entry, parameters: ["archive": entry.isArchived.int, "starred": entry.isStarred.int])
                            }
                        }
                    }
                }
        }
    }
}
