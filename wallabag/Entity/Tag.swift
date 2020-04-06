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

extension Tag {
    @nonobjc public class func fetchRequestSorted() -> NSFetchRequest<Tag> {
        let fetchRequest = NSFetchRequest<Tag>(entityName: "Tag")
        let sortDescriptor = NSSortDescriptor(key: "label", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }

    @nonobjc public class func fetchOneById(_ id: Int) -> NSFetchRequest<Tag> {
        let fetchRequest = NSFetchRequest<Tag>(entityName: "Tag")
        fetchRequest.predicate = NSPredicate(format: "id == %ld", id)
        return fetchRequest
    }

    @NSManaged public dynamic var id: Int
    @NSManaged public dynamic var label: String
    @NSManaged public dynamic var slug: String
}
