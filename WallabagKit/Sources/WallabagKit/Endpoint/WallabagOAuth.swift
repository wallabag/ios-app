//
//  WallabagOAuth.swift
//  wallabag
//
//  Created by Marinel Maxime on 13/10/2019.
//

import Foundation

public struct WallabagToken: Decodable {
    public let accessToken: String
    public let expiresIn: Int
    public let tokenType: String
    public let refreshToken: String
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

    // swiftlint:disable force_try
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
