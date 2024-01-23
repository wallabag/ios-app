import Foundation

public enum WallabagConfigEndpoint: WallabagKitEndpoint {
    public typealias Object = WallabagConfig

    case get

    public func method() -> HttpMethod {
        .get
    }

    public func endpoint() -> String {
        "/api/config"
    }

    public func getBody() -> Data {
        "".data(using: .utf8)!
    }

    public func requireAuth() -> Bool {
        true
    }
}
