//
//  WallabagError.swift
//  wallabag
//
//  Created by Marinel Maxime on 15/02/2020.
//

import Foundation

enum WallabagError: Error {
    case syncError(String)
}

extension WallabagError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case let .syncError(error):
            return "\(error)"
        }
    }
}
