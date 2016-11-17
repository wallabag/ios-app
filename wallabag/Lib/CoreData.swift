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
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    @available(iOS 9.3, *)
    static var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    @available(iOS 9.3, *)
    static var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "fr.district-web.Radio_Stream_Live" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }()

    @available(iOS 9.3, *)
    static var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: containerName!, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    @available(iOS 9.3, *)
    static var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let url = applicationDocumentsDirectory.appendingPathComponent(containerName! + ".sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
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
        if #available(iOS 10.0, *) {
            let result = try! persistentContainer.viewContext.fetch(request as! NSFetchRequest<NSFetchRequestResult>)
            return result as! [NSManagedObject]
        } else {
            let result = try! managedObjectContext.fetch(request as! NSFetchRequest<NSFetchRequestResult>)
            return result as! [NSManagedObject]
        }
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
