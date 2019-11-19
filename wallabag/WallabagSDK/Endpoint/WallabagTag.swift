//
//  WallabagTag.swift
//  wallabag
//
//  Created by Marinel Maxime on 23/10/2019.
//

import Foundation

enum WallabagTagEndpoint: WallabagKitEndpoint {
    case get

    func method() -> HttpMethod {
        .get
    }

    func endpoint() -> String {
        "/api/tags"
    }

    func getBody() -> Data {
        "".data(using: .utf8)!
    }

    func requireAuth() -> Bool {
        true
    }
}

public struct WallabagTag: Decodable {
    let id: Int
    let label: String
    let slug: String
}
