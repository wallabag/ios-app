//
//  Tag.swift
//  wallabag
//
//  Created by maxime marinel on 08/05/2019.
//

import CoreData
import Foundation

class Tag: NSManagedObject, Identifiable {
    @Published var isChecked: Bool = false
}

public extension Tag {
    @nonobjc class func fetchRequestSorted() -> NSFetchRequest<Tag> {
        let fetchRequest = NSFetchRequest<Tag>(entityName: "Tag")
        let sortDescriptor = NSSortDescriptor(key: "label", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }

    @nonobjc class func fetchOneById(_ id: Int) -> NSFetchRequest<Tag> {
        let fetchRequest = NSFetchRequest<Tag>(entityName: "Tag")
        fetchRequest.predicate = NSPredicate(format: "id == %ld", id)
        return fetchRequest
    }

    @NSManaged dynamic var id: Int
    @NSManaged dynamic var label: String
    @NSManaged dynamic var slug: String
}
