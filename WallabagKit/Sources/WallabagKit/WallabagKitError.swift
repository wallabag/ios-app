//
//  WallabagKitError.swift
//  wallabag
//
//  Created by Marinel Maxime on 13/10/2019.
//

import Foundation

public enum WallabagKitError: Error {
    case authenticationRequired
    case serverError
    case invalidApiEndpoint
    case jsonError(json: WallabagJsonError)
    case decodingJSON
    case invalidToken
    case wrap(error: Error)
}

public struct WallabagJsonError: Decodable {
    public let error: String
    public let errorDescription: String
}
