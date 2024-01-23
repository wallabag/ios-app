import Foundation

enum WallabagOauth: WallabagKitEndpoint {
    func method() -> HttpMethod {
        .post
    }

    func endpoint() -> String {
        switch self {
        case .request:
            "/oauth/v2/token"
        }
    }

    func getBody() -> Data {
        switch self {
        case let .request(clientId, clientSecret, username, password):
            // swiftlint:disable:next force_try
            try! JSONSerialization.data(withJSONObject: [
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
