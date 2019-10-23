//
//  WallabagTag.swift
//  wallabag
//
//  Created by Marinel Maxime on 23/10/2019.
//

import Foundation

public struct WallabagTag: Decodable {
    let id: Int
    let label: String
    let slug: String
}
