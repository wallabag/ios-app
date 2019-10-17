//
//  WallabagOAuth.swift
//  wallabag
//
//  Created by Marinel Maxime on 13/10/2019.
//

import Foundation

struct WallabagToken: Decodable {
    let accessToken: String
    let expiresIn: Int
    let tokenType: String
    let refreshToken: String
}

enum WallabagOauth: WallabagKitEndpoint {
    func method() -> HttpMethod {
        .post
    }

    func endpoint() -> String {
        switch self {
        case .request:
            return "/oauth/v2/token"
        }
    }

    func getBody() -> Data {
        switch self {
        case let .request(clientId, clientSecret, username, password):
            return try! JSONSerialization.data(withJSONObject: [
                "grant_type": "password",
                "client_id": clientId,
                "client_secret": clientSecret,
                "username": username,
                "password": password,
            ], options: .prettyPrinted)
        }
    }

    func requireAuth() -> Bool {
        false
    }

    case request(clientId: String, clientSecret: String, username: String, password: String)
}
