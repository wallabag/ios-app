//
//  CoreDataViewContext.swift
//  wallabag
//
//  Created by Marinel Maxime on 21/10/2019.
//

import CoreData
import Foundation

@propertyWrapper
struct CoreDataViewContext {
    var wrappedValue: NSManagedObjectContext {
        CoreData.shared.viewContext
    }
}
