//
//  Tag.swift
//  wallabag
//
//  Created by maxime marinel on 08/05/2019.
//

import Foundation
import RealmSwift

final class Tag: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var label: String = ""
    @objc dynamic var slug: String = ""

    override class func primaryKey() -> String? {
        return "id"
    }
}
