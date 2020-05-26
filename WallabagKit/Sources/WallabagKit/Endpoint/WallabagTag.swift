//
//  WallabagTag.swift
//  wallabag
//
//  Created by Marinel Maxime on 23/10/2019.
//

import Foundation

public enum WallabagTagEndpoint: WallabagKitEndpoint {
    case get

    public func method() -> HttpMethod {
        .get
    }

    public func endpoint() -> String {
        "/api/tags"
    }

    public func getBody() -> Data {
        "".data(using: .utf8)!
    }

    public func requireAuth() -> Bool {
        true
    }
}

public struct WallabagTag: Decodable {
    public let id: Int
    public let label: String
    public let slug: String
}
