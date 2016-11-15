//
//  Tag.swift
//  wallabag
//
//  Created by maxime marinel on 25/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import Foundation

struct Tag: Hashable {
    let id: Int
    let label: String
    let slug: String

    var hashValue: Int {
        return id
    }

    init(fromDictionary: [String: Any]) {
        id = fromDictionary["id"] as! Int
        label = fromDictionary["label"] as! String
        slug = fromDictionary["slug"] as! String
    }
}

func ==(tag1: Tag, tag2: Tag) -> Bool {
    return tag1.id == tag2.id
}
