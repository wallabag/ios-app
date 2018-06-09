//
//  WallabagKitCollection.swift
//  wallabag
//
//  Created by maxime marinel on 09/06/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation

struct WallabagKitCollection<T: Decodable>: Decodable {
    let limit: Int
    let page: Int
    let pages: Int
    let total: Int
    let items: [T]

    enum CodingKeys: String, CodingKey {
        case limit
        case page
        case pages
        case total
        case embedded = "_embedded"
    }

    enum EmbeddedItems: String, CodingKey {
        case items
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let embeddedContainer = try container.nestedContainer(keyedBy: EmbeddedItems.self, forKey: .embedded)
        limit = try container.decode(Int.self, forKey: .limit)
        page = try container.decode(Int.self, forKey: .page)
        pages = try container.decode(Int.self, forKey: .pages)
        total = try container.decode(Int.self, forKey: .total)
        items = try embeddedContainer.decode([T].self, forKey: .items)
    }
}
