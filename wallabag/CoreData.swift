//
//  CoreData.swift
//  wallabag
//
//  Created by maxime marinel on 27/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import Foundation
import CoreData

final class CoreData: NSObject {

    static var containerName: String?

    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName!)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    static func save() {
        try! context.save()
    }

    static func execute(_ request: NSPersistentStoreRequest) -> NSPersistentStoreResult {
        let result = try! persistentContainer.viewContext.execute(request)

        return result
    }

    static func fetch(_ request: NSPersistentStoreRequest) -> [NSManagedObject] {
        let result = try! persistentContainer.viewContext.fetch(request as! NSFetchRequest<NSFetchRequestResult>)

        return result as! [NSManagedObject]
    }

    static func findAll(_ entity: String) -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)

        return fetch(request)
    }

    static func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
