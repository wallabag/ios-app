//
//  Server.swift
//  wallabag
//
//  Created by maxime marinel on 26/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import CoreData
import Foundation

@objc(Server)
class Server: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Server> {
        return NSFetchRequest<Server>(entityName: "Server")
    }

    @NSManaged var host: String
    @NSManaged var client_secret: String
    @NSManaged var client_id: String
    @NSManaged var username: String
    @NSManaged var password: String

}
