//
//  CoreData.swift
//  wallabag
//
//  Created by Marinel Maxime on 21/10/2019.
//

import CoreData
import Foundation

final class CoreData {
    static let shared = CoreData()

    private init() {}

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

        return container
    }()

    lazy var viewContext: NSManagedObjectContext = {
        //try? persistentContainer.viewContext.setQueryGenerationFrom(.current)
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
