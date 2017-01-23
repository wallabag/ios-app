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

    @available(iOS 10.0, *)
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName!)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    @available(iOS 9.3, *)
    static var managedObjectContext: NSManagedObjectContext = {
        let coordinator = persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    @available(iOS 9.3, *)
    static var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }()

    @available(iOS 9.3, *)
    static var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: containerName!, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    @available(iOS 9.3, *)
    static var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let url = applicationDocumentsDirectory.appendingPathComponent(containerName! + ".sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }

        return coordinator
    }()

    static var context: NSManagedObjectContext {
        if #available(iOS 10.0, *) {
            return persistentContainer.viewContext
        } else {
            return managedObjectContext
        }
    }

    static func save() throws {
        try context.save()
    }

    static func fetch(_ request: NSPersistentStoreRequest) -> [NSManagedObject] {
        let result = try! context.fetch(request as! NSFetchRequest<NSFetchRequestResult>)
        return result as! [NSManagedObject]
    }

    static func findAll(_ entity: String) -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)

        return fetch(request)
    }

    static func deleteAll(_ entity: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        try! context.execute(NSBatchDeleteRequest(fetchRequest: request))
    }

    static func saveContext() {
        if context.hasChanges {
            do {
                try save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
