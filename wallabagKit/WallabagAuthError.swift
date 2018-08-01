//
//  WallabagAuthError.swift
//  wallabag
//
//  Created by maxime marinel on 09/06/2018.
//  Copyright © 2018 maxime marinel. All rights reserved.
//

import Foundation

public struct WallabagAuthError: Codable {
    public let error: String
    public let description: String
    enum CodingKeys: String, CodingKey {
        case error
        case description = "error_description"
    }
}
