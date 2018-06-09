//
//  WallabagAuthError.swift
//  wallabag
//
//  Created by maxime marinel on 09/06/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation

struct WallabagAuthError: Codable {
    let error: String
    let description: String
    enum CodingKeys: String, CodingKey {
        case error
        case description = "error_description"
    }
}
