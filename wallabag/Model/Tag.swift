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
        guard let id = fromDictionary["id"] as? Int,
            let label = fromDictionary["label"] as? String,
            let slug = fromDictionary["slug"] as? String else {
            fatalError("Invalid tag")
        }

        self.id = id
        self.label = label
        self.slug = slug
    }
}

func == (tag1: Tag, tag2: Tag) -> Bool {
    return tag1.id == tag2.id
}
