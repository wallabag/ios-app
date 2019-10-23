//
//  Tag.swift
//  wallabag
//
//  Created by maxime marinel on 08/05/2019.
//

import Foundation
import CoreData

class Tag: NSManagedObject, Identifiable {}

extension Tag {
    
    @nonobjc public class func fetchRequestSorted() -> NSFetchRequest<Tag> {
        let fetchRequest = NSFetchRequest<Tag>(entityName: "Tag")
        let sortDescriptor = NSSortDescriptor(key: "label", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    @NSManaged public dynamic var id: Int
    @NSManaged public dynamic var label: String
    @NSManaged public dynamic var slug: String
    
}

/*final class Tag: Object {
 @objc public dynamic var id: Int = 0
 @objc public dynamic var label: String?
 @objc public dynamic var slug: String?
 //let entries = LinkingObjects(fromType: Entry.self, property: "tags")
 
 override class func primaryKey() -> String? {
 return "id"
 }
 }*/
