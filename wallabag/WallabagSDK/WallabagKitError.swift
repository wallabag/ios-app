//
//  WallabagKitError.swift
//  wallabag
//
//  Created by Marinel Maxime on 13/10/2019.
//

import Foundation

public enum WallabagKitError: Error {
    case unknown
    case jsonError(json: WallabagJsonError)
    case wrap(error: Error)
}

public struct WallabagJsonError: Decodable {
    let error: String
    let errorDescription: String
}
