//
//  CoreData.swift
//  wallabag
//
//  Created by Marinel Maxime on 21/10/2019.
//

import Combine
import CoreData
import Foundation
import UIKit.UIApplication

final class CoreData {
    static let shared = CoreData()

    private var cancellables = Set<AnyCancellable>()

    private init() {
        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink(receiveValue: didEnterBackgroundNotification)
            .store(in: &cancellables)
    }

    private func didEnterBackgroundNotification(_: Notification) {
        saveContext()
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "wallabagStore")

        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Could not retrieve a persistent store description.")
        }

        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.automaticallyMergesChangesFromParent = true

        return container
    }()

    lazy var viewContext: NSManagedObjectContext = {
        self.persistentContainer.viewContext
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        context.mergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
