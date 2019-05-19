//
//  Tag.swift
//  wallabag
//
//  Created by maxime marinel on 08/05/2019.
//

import Foundation
import RealmSwift

final class Tag: Object {
    @objc public dynamic var id: Int = 0
    @objc public dynamic var label: String?
    @objc public dynamic var slug: String?
    let entries = LinkingObjects(fromType: Entry.self, property: "tags")

    override class func primaryKey() -> String? {
        return "id"
    }
}
