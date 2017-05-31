//
//  Entry+CoreDataProperties.swift
//  wallabag
//
//  Created by maxime marinel on 08/05/2017.
//  Copyright © 2017 maxime marinel. All rights reserved.
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchEntryRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var content: String?
    @NSManaged public var created_at: NSDate?
    @NSManaged public var domain_name: String?
    @NSManaged public var id: Int64
    @NSManaged public var is_archived: Bool
    @NSManaged public var is_starred: Bool
    @NSManaged public var preview_picture: String?
    @NSManaged public var title: String?
    @NSManaged public var updated_at: NSDate?
    @NSManaged public var url: String?
    @NSManaged public var reading_time: Int64

}
