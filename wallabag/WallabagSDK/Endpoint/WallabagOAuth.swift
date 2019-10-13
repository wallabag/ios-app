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
            let mutable = NSMutableData(data: "grant_type=password".data(using: .utf8)!)
            mutable.append("&client_id=\(clientId)".data(using: .utf8)!)
            mutable.append("&client_secret=\(clientSecret)".data(using: .utf8)!)
            mutable.append("&username=\(username)".data(using: .utf8)!)
            mutable.append("&password=\(password)".data(using: .utf8)!)
            return mutable as Data
        }
    }

    func requireAuth() -> Bool {
        false
    }

    case request(clientId: String, clientSecret: String, username: String, password: String)
}
